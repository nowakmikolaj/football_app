import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_app/providers/FootballApi.dart';
import 'package:http/http.dart' as http;

import '../models/country.dart';
import '../models/league.dart';

class LeaguesProvider extends InheritedWidget {
  const LeaguesProvider(
    Key? key,
    Widget child,
    this.leagues,
  ) : super(
          key: key,
          child: child,
        );

  final List<League> leagues;

  static Future<List<League>> fetchLeagues() async {
    http.Response response = await http.get(
      FootballApi.leaguesUrl,
      headers: FootballApi.headers,
    );

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];

    Map<String, dynamic> res = json.decode(response.body);
    var leagues = res['response'];
    List<League> fetchedLeagues = [];

    print('Remaining requests: ${requestsLeft}');

    for (int i = 0; i < leagues.length; i++) {
      fetchedLeagues.add(League.fromJson(
          leagues[i]['league'], Country.fromJson(leagues[i]['country'])));
    }

    leagues = fetchedLeagues;
    return fetchedLeagues;
  }

  @override
  bool updateShouldNotify(LeaguesProvider oldWidget) =>
      oldWidget.leagues != leagues;

  static List<League> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LeaguesProvider>()!.leagues;
}
