import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/country.dart';

class CountryDataSource {
  static final instance = CountryDataSource._();

  CountryDataSource._();

  Future<List<Country>> getCountries() async {
    return FirestoreService.getCountries();
  }

  void migrateCountries(List<Country> countries) {
    for (final country in countries) {
      FirebaseFirestore.instance
          .collection("countries")
          .doc(country.name)
          .set(country.toFirestore())
          .onError(
              (error, stackTrace) => print("error writing country $error"));
    }
  }
}
