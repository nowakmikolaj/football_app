import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_app/providers/FootballApi.dart';
import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountriesProvider {
  static Future<List<Country>> fetchCountries() async {
    http.Response response = await http.get(
      FootballApi.countriesUrl,
      headers: FootballApi.headers,
    );

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];

    Map<String, dynamic> res = json.decode(response.body);
    var countries = res['response'];
    List<Country> fetchedCountries = [];

    print('[countries] Remaining requests: ${requestsLeft}');

    for (int i = 0; i < countries.length; i++) {
      fetchedCountries.add(Country.fromJson(countries[i]));
      // fetchedCountries.add(League.fromJson(
      // countries[i]['league'], Country.fromJson(countries[i]['country'])));
    }

    fetchedCountries.sort((a, b) => a.compareTo(b));

    countries = fetchedCountries;
    return fetchedCountries;
  }
}
