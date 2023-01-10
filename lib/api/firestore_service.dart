import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
        .doc()
        .set(bet.toFirestore())
        .onError((error, stackTrace) => print("${error.toString()}"));
  }

  static Future placeBet(Bet bet) async {
    addTeam(bet.fixture!.homeTeam);
    addTeam(bet.fixture!.awayTeam);
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

    for (final item in data) {
      final fixtureDoc = await getItem(item['fixture'].path);
      final leagueDoc = await getItem(fixtureDoc!['league'].path);
      final homeTeamDoc = await getItem(fixtureDoc['homeTeamId'].path);
      final awayTeamDoc = await getItem(fixtureDoc['awayTeamId'].path);
      final goals = Score.fromJson(fixtureDoc);

      final fixture = Fixture.fromFirebase(
        json: fixtureDoc,
        league: League.fromJson(leagueDoc!),
        homeTeam: Team.fromJson(homeTeamDoc!),
        awayTeam: Team.fromJson(awayTeamDoc!),
        goals: goals,
      );

      bets.add(Bet.fromJson(json: item, fixture: fixture));
    }

    bets.sort(((a, b) => a.compareTo(b)));

    return bets;
  }

  static Future<Map<String, dynamic>?> getItem(
    String path,
  ) async {
    final data = (await FirebaseFirestore.instance.doc(path).get()).data();

    return data;
  }
}
