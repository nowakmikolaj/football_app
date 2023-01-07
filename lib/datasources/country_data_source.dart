import 'dart:convert';
import 'package:football_app/api/endpoints.dart';
import 'package:football_app/api/football_client.dart';

import '../models/country.dart';

class CountryDataSource {
  static final instance = CountryDataSource._();

  CountryDataSource._();

  Future<List<Country>> getCountries() async {
    final response = await FootballClient.get(
      url: Endpoints.countriesUrl,
      headers: FootballClient.headers,
    );

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('[countries] Remaining requests: ${requestsLeft}');

    Map<String, dynamic> res = json.decode(response.body);
    var countries = res['response'];
    List<Country> fetchedCountries = [];
    for (int i = 0; i < countries.length; i++) {
      fetchedCountries.add(Country.fromJson(countries[i]));
    }

    return fetchedCountries;
  }
}
