// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_app/api/endpoints.dart';
import 'package:football_app/datasources/football_data_source.dart';
import 'package:football_app/models/abstract/searchable_tile_element.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/models/team.dart';

class FirestoreDataSource {
  late CollectionReference<Map<String, dynamic>> usersCollection;
  late CollectionReference<Map<String, dynamic>> countriesCollection;
  late CollectionReference<Map<String, dynamic>> fixturesCollection;
  late CollectionReference<Map<String, dynamic>> leaguesCollection;
  late CollectionReference<Map<String, dynamic>> betsCollection;

  static final instance = FirestoreDataSource._();

  FirestoreDataSource._() {
    usersCollection = FirebaseFirestore.instance.collection('users');
    countriesCollection = FirebaseFirestore.instance.collection('countries');
    fixturesCollection = FirebaseFirestore.instance.collection('fixtures');
    leaguesCollection = FirebaseFirestore.instance.collection('leagues');
    betsCollection = FirebaseFirestore.instance.collection('bets');
  }

  Future<List> getFavouriteLeagueIds() async {
    List favLeagueIds = [];

    try {
      final data = (await usersCollection
              .doc(FirebaseAuth.instance.currentUser!.email)
              .get())
          .data();

      favLeagueIds = data?['favourite_leagues'];
    } catch (e) {
      print(e.toString());
    }

    return favLeagueIds;
  }

  Future<List<League>> getFavouriteLeagues() async {
    final favLeagueIds = await getFavouriteLeagueIds();
    if (favLeagueIds.isEmpty) {
      return [];
    }

    List<League> result = [];
    List<Map<String, dynamic>> leagues = [];
    try {
      for (int i = 0; i < favLeagueIds.length; i += 10) {
        leagues = [
          ...leagues,
          ...(await leaguesCollection
                  .where("id",
                      whereIn: favLeagueIds
                          .getRange(i, min(i + 10, favLeagueIds.length))
                          .toList())
                  .get())
              .docs
              .map((e) => e.data())
              .toList()
        ];
      }

      for (final league in leagues) {
        result.add(League.fromJson(league,
            country: Country(league['country'], '', '')));
      }
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Future<List<League>> getLeagues() async {
    List<League> leagues = [];
    try {
      final data = (await leaguesCollection.get()).docs.map((e) => e.data());

      for (final item in data) {
        leagues.add(
            League.fromJson(item, country: Country(item['country'], '', '')));
      }
    } catch (e) {
      print(e.toString());
    }

    return leagues;
  }

  Future<List<SearchableTileElement>> getSearchData() async {
    return [...(await getLeagues()), ...(await getCountries())];
  }

  Future<List<League>> getLeaguesByCountry(String country) async {
    List<League> leagues = [];
    try {
      final data =
          (await leaguesCollection.where("country", isEqualTo: country).get())
              .docs
              .map((e) => e.data());

      for (final item in data) {
        leagues.add(
            League.fromJson(item, country: Country(item['country'], '', '')));
      }
    } catch (e) {
      print(e.toString());
    }

    return leagues;
  }

  Future<List<Country>> getCountries() async {
    List<Country> countries = [];
    try {
      final data =
          (await countriesCollection.get()).docs.map((item) => item.data());

      for (final item in data) {
        countries.add(Country.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return countries;
  }

  void migrateLeagues(List<League> leagues) {
    try {
      for (int i = 0; i < leagues.length; i++) {
        final item = leagues[i];

        leaguesCollection
            .doc(leagues[i].leagueId.toString())
            .set(item.toFirestore())
            .onError(
                (error, stackTrace) => print("error writing league $error"));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isFavourite(League league) async {
    final fav = await getFavouriteLeagueIds();

    return fav.contains(league.leagueId);
  }

  Future addToFavourites(League league) async {
    try {
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "favourite_leagues": FieldValue.arrayUnion([league.leagueId]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future removeFromFavourites(League league) async {
    try {
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "favourite_leagues": FieldValue.arrayRemove([league.leagueId]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future addUser(String email) async {
    try {
      await usersCollection.doc(email).set({"favourite_leagues": []}).onError(
          (error, stackTrace) => print("error writing user $error"));
    } catch (e) {
      print(e.toString());
    }
  }

  Future addFixture(Fixture fixture) async {
    try {
      await fixturesCollection
          .doc(fixture.fixtureId.toString())
          .set(fixture.toFirestore())
          .onError((error, stackTrace) => print(error.toString()));
    } catch (e) {
      print(e.toString());
    }
  }

  Future addBet(Bet bet) async {
    try {
      await betsCollection
          .doc(
              "${FirebaseAuth.instance.currentUser!.email}-${bet.fixture!.fixtureId}")
          .set(bet.toFirestore())
          .onError((error, stackTrace) => print(error.toString()));
    } catch (e) {
      print(e.toString());
    }
  }

  Future placeBet(Bet bet) async {
    addFixture(bet.fixture!);
    addBet(bet);
  }

  Future<List<Bet>?> getBet(int fixtureId) async {
    Iterable<Map<String, dynamic>> data = [];
    try {
      data = (await betsCollection
              .where("userId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .where("id", isEqualTo: fixtureId)
              .get())
          .docs
          .map((e) => e.data());

      if (data.isEmpty) return [];
    } catch (e) {
      print(e.toString());
    }
    return [Bet.fromJson(json: data.first)];
  }

  Future<List<Map<String, dynamic>>> getFixtures(
    List<int> ids,
  ) async {
    Iterable<Map<String, dynamic>> data = [];
    try {
      data = (await fixturesCollection.where("id", whereIn: ids).get())
          .docs
          .map((e) => e.data());
    } catch (e) {
      print(e.toString());
    }
    return data.toList();
  }

  Future<List<Bet>> getBetsByUser() async {
    try {
      final data = (await betsCollection
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
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  void migrateBets(List<Bet> bets) {
    final batch = FirebaseFirestore.instance.batch();

    try {
      for (var bet in bets) {
        final docRef = betsCollection.doc(
            "${FirebaseAuth.instance.currentUser!.email}-${bet.fixture!.fixtureId}");
        batch.update(docRef, {"points": bet.points});
      }
      batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  void migrateFixtures(List<Fixture> fixtures) {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var fixture in fixtures) {
        final docRef = fixturesCollection.doc(fixture.fixtureId.toString());
        batch.set(docRef, fixture.toFirestore());
      }

      batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  void migrateCountries(List<Country> countries) {
    try {
      for (final country in countries) {
        countriesCollection
            .doc(country.name)
            .set(country.toFirestore())
            .onError(
                (error, stackTrace) => print("error writing country $error"));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Fixture>> getFixtureByIds(List<int> ids) async {
    return await FootballDataSource.instance.getFixtures(
      FootballApiEndpoints.getFixturesByIdsUrl(ids),
    );
  }

  Future<Map<String, dynamic>?> getItem(
    String path,
  ) async {
    try {
      final data = (await FirebaseFirestore.instance.doc(path).get()).data();
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
