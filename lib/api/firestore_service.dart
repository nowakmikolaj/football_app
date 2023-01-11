import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_app/api/endpoints.dart';
import 'package:football_app/datasources/league_data_source.dart';
import 'package:football_app/models/abstract/searchable_tile_element.dart';
import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/models/team.dart';

class FirestoreService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<List> getFavouriteLeagueIds() async {
    final data = (await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get())
        .data();

    List favLeagueIds = data?['favourite_leagues'];
    return favLeagueIds;
  }

  static Future<List<League>> getFavouriteLeagues() async {
    final favLeagueIds = await getFavouriteLeagueIds();
    if (favLeagueIds.isEmpty) {
      return [];
    }

    final leagues = (await FirebaseFirestore.instance
            .collection("leagues")
            .where("id", whereIn: favLeagueIds)
            .get())
        .docs
        .map((e) => e.data())
        .toList();

    List<League> result = [];
    for (final league in leagues) {
      result.add(
          League.fromJson(league, country: Country(league['country'], '', '')));
    }

    return result;
  }

  static Future<List<League>> getLeagues() async {
    final data = (await FirebaseFirestore.instance.collection("leagues").get())
        .docs
        .map((e) => e.data());

    List<League> leagues = [];
    for (final item in data) {
      leagues.add(
          League.fromJson(item, country: Country(item['country'], '', '')));
    }

    return leagues;
  }

  static Future<List<SearchableTileElement>> getSearchData() async {
    return [...(await getLeagues()), ...(await getCountries())];
  }

  static Future<List<League>> getLeaguesByCountry(String country) async {
    final data = (await FirebaseFirestore.instance
            .collection("leagues")
            .where("country", isEqualTo: country)
            .get())
        .docs
        .map((e) => e.data());

    List<League> leagues = [];
    for (final item in data) {
      leagues.add(
          League.fromJson(item, country: Country(item['country'], '', '')));
    }

    return leagues;
  }

  static Future<List<Country>> getCountries() async {
    final data =
        (await FirebaseFirestore.instance.collection("countries").get())
            .docs
            .map((item) => item.data());

    List<Country> countries = [];
    for (final item in data) {
      countries.add(Country.fromJson(item));
    }
    return countries;
  }

  static void migrateLeagues(List<League> leagues) {
    for (int i = 0; i < leagues.length; i++) {
      final item = leagues[i];

      FirebaseFirestore.instance
          .collection("leagues")
          .doc(leagues[i].leagueId.toString())
          .set(item.toFirestore())
          .onError((error, stackTrace) => print("error writing league $error"));
    }
  }

  static Future<bool> isFavourite(League league) async {
    final fav = await getFavouriteLeagueIds();

    return fav.contains(league.leagueId);
  }

  static Future addToFavourites(League league) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "favourite_leagues": FieldValue.arrayUnion([league.leagueId]),
    });
  }

  static Future removeFromFavourites(League league) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "favourite_leagues": FieldValue.arrayRemove([league.leagueId]),
    });
  }

  static Future addUser(String email) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .set({"favourite_leagues": []}).onError(
            (error, stackTrace) => print("error writing user $error"));
  }

  static Future addTeam(Team team) async {
    await FirebaseFirestore.instance
        .collection("teams")
        .doc(team.teamId.toString())
        .set(team.toFirestore())
        .onError((error, stackTrace) => print("${error.toString()}"));
  }

  static Future addFixture(Fixture fixture) async {
    await FirebaseFirestore.instance
        .collection("fixtures")
        .doc(fixture.fixtureId.toString())
        .set(fixture.toFirestore())
        .onError((error, stackTrace) => print("${error.toString()}"));
  }

  static Future addBet(Bet bet) async {
    await FirebaseFirestore.instance
        .collection("bets")
        .doc(
            "${FirebaseAuth.instance.currentUser!.email}-${bet.fixture!.fixtureId}")
        .set(bet.toFirestore())
        .onError((error, stackTrace) => print("${error.toString()}"));
  }

  static Future placeBet(Bet bet) async {
    // addTeam(bet.fixture!.homeTeam);
    // addTeam(bet.fixture!.awayTeam);
    addFixture(bet.fixture!);
    addBet(bet);
  }

  static Future<List<Bet>?> getBet(int fixtureId) async {
    final data = (await FirebaseFirestore.instance
            .collection("bets")
            .where("userId",
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .where("id", isEqualTo: fixtureId)
            .get())
        .docs
        .map((e) => e.data());

    if (data.isEmpty) return [];

    return [Bet.fromJson(json: data.first)];
  }

  static Future<List<Map<String, dynamic>>> getFixtures(
    List<int> ids,
  ) async {
    final data = (await FirebaseFirestore.instance
            .collection("fixtures")
            .where("id", whereIn: ids)
            .get())
        .docs
        .map((e) => e.data());

    return data.toList();
  }

  static Future<List<Bet>> getBetsByUser() async {
    final data = (await FirebaseFirestore.instance
            .collection("bets")
            .where("userId",
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get())
        .docs
        .map((e) => e.data());

    List<Bet> bets = [];
    List<Bet> betsToSettle = [];
    List<Bet> betsToSettleWithFixtureUpdate = [];
    if (data.isNotEmpty) {
      for (final item in data) {
        final fixtureDoc = await getItem(item['fixture'].path);
        final leagueDoc = await getItem(fixtureDoc!['league'].path);
        final goals = Score.fromJson(fixtureDoc);

        final fixture = Fixture.fromFirestore(
          json: fixtureDoc,
          league: League.fromJson(leagueDoc!),
          homeTeam: Team.fromJson(fixtureDoc['homeTeam']),
          awayTeam: Team.fromJson(fixtureDoc['awayTeam']),
          goals: goals,
        );

        final bet = Bet.fromJson(json: item, fixture: fixture);

        if (bet.points == null) {
          if (bet.fixture!.isFinished()) {
            // zwykłe naliczenie punktów
            betsToSettle.add(bet);
          } else if (bet.fixture!.shouldSettleBet()) {
            // trzeba zaktualizować fixture
            betsToSettleWithFixtureUpdate.add(bet);
          } else {} // nic nie robimy, mecz trwa
        }

        bets.add(bet);
      }
    }

    for (final bet in betsToSettle) {
      if (!bet.settle()) {
        betsToSettleWithFixtureUpdate.add(bet);
      }
    }

    List<Fixture> updatedFixtures = [];
    for (int i = 0; i < betsToSettleWithFixtureUpdate.length;) {
      List<int> fixtureIdsToUpdate = [];
      for (int j = 0;
          j < min(20, betsToSettleWithFixtureUpdate.length);
          j++, i++) {
        fixtureIdsToUpdate
            .add(betsToSettleWithFixtureUpdate[i].fixture!.fixtureId);
      }
      final updated = await getFixtureByIds(fixtureIdsToUpdate);
      updatedFixtures = [...updatedFixtures, ...updated];
    }

    if (updatedFixtures.isNotEmpty) {
      migrateFixtures(updatedFixtures);

      for (final fixture in updatedFixtures) {
        final betRef = bets
            .where((bet) => bet.fixture!.fixtureId == fixture.fixtureId)
            .single;
        betRef.fixture = fixture;
        if (fixture.isFinished()) {
          betRef.settle();
        }
      }

      migrateBets(bets);
    }

    bets.sort(((a, b) => a.compareTo(b)));

    return bets;
  }

  static void migrateBets(List<Bet> bets) {
    final batch = FirebaseFirestore.instance.batch();
    for (var bet in bets) {
      final docRef = FirebaseFirestore.instance.collection("bets").doc(
          "${FirebaseAuth.instance.currentUser!.email}-${bet.fixture!.fixtureId}");
      batch.update(docRef, {"points": bet.points});
    }
    batch.commit();
  }

  static void migrateFixtures(List<Fixture> fixtures) {
    final batch = FirebaseFirestore.instance.batch();
    for (var fixture in fixtures) {
      final docRef = FirebaseFirestore.instance
          .collection("fixtures")
          .doc(fixture.fixtureId.toString());
      batch.set(docRef, fixture.toFirestore());
    }

    batch.commit();
  }

  static Future<List<Fixture>> getFixtureByIds(List<int> ids) async {
    return await LeagueDataSource.instance.getFixtures(
      FootballApiEndpoints.getFixturesByIdsUrl(ids),
    );
  }

  static Future<Map<String, dynamic>?> getItem(
    String path,
  ) async {
    final data = (await FirebaseFirestore.instance.doc(path).get()).data();

    return data;
  }
}
