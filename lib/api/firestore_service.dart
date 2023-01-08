import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/league.dart';

class FirestoreService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<List> getFavouriteLeagues() async {
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email);

    final snapshot = await docRef.get();
    final data = snapshot.data();
    List leagueIds = data?['favourite_leagues'];

    return leagueIds;
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
}
