import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_app/providers/FootballApi.dart';
import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountriesProvider extends InheritedWidget {
  const CountriesProvider({
    Key? key,
    required Widget child,
    required this.countries,
  }) : super(
          key: key,
          child: child,
        );

  final List<Country> countries;

  static Future<List<Country>> fetchCountries() async {
    http.Response response = await http.get(
      FootballApi.countriesUrl,
      headers: FootballApi.headers,
    );

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];

    Map<String, dynamic> res = json.decode(response.body);
    var countries = res['response'];
    List<Country> fetchedCountries = [];

    print('Remaining requests: ${requestsLeft}');

    for (int i = 0; i < countries.length; i++) {
      fetchedCountries.add(Country.fromJson(countries[i]));
      // fetchedCountries.add(League.fromJson(
      // countries[i]['league'], Country.fromJson(countries[i]['country'])));
    }

    fetchedCountries.sort((a, b) => a.compareTo(b));

    countries = fetchedCountries;
    return fetchedCountries;
  }

  @override
  bool updateShouldNotify(CountriesProvider oldWidget) =>
      oldWidget.countries != countries;

  static List<Country> of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CountriesProvider>()!
      .countries;
}
