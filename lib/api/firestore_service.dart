import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/league.dart';

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
}
