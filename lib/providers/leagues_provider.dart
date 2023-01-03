import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_app/providers/FootballApi.dart';
import 'package:http/http.dart' as http;

import '../models/country.dart';
import '../models/fixture.dart';
import '../models/league.dart';
import '../models/match_result.dart';
import '../models/score.dart';
import '../models/team.dart';

class LeaguesProvider {

  static Future<List<League>> fetchLeagues(String country) async {
    http.Response response = await http.get(
      Uri.parse('${FootballApi.leaguesByCountryUrl}$country'),
      headers: FootballApi.headers,
    );

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];

    Map<String, dynamic> res = json.decode(response.body);
    var leagues = res['response'];
    List<League> fetchedLeagues = [];

    print('[leagues] Remaining requests: ${requestsLeft}');

    for (int i = 0; i < leagues.length; i++) {
      fetchedLeagues.add(
        League.fromJson(
          leagues[i]['league'],
          country: Country.fromJson(leagues[i]['country']),
        ),
      );
    }

    fetchedLeagues.sort((a, b) => a.compareTo(b));

    leagues = fetchedLeagues;
    return fetchedLeagues;
  }

  static Future<List<Fixture>> getFixtures(int leagueId,
      {int season = 2022}) async {
    http.Response response = await http.get(
      FootballApi.getFixturesUrl(leagueId, season),
      headers: FootballApi.headers,
    );

    Map<String, dynamic> res = json.decode(response.body);
    var fixtures = res['response'];
    List<Fixture> fetchedFixtures = [];

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('[fixtures] Remaining requests: $requestsLeft');

    for (int i = 0; i < fixtures.length; i++) {
      fetchedFixtures.add(
        Fixture.fromJson(
          fixtures[i]['fixture'],
          League.fromJson(fixtures[i]['league']),
          Team.fromJson(fixtures[i]['teams']['home']),
          Team.fromJson(fixtures[i]['teams']['away']),
          MatchResult(
            halfTime: Score.fromJson(fixtures[i]['score']['halftime']),
            fullTime: Score.fromJson(fixtures[i]['score']['fulltime']),
            extraTime: Score.fromJson(fixtures[i]['score']['extratime']),
            penalty: Score.fromJson(fixtures[i]['score']['penalty']),
          ),
        ),
      );
    }

    fetchedFixtures.sort((a, b) => a.compareTo(b));

    fixtures = fetchedFixtures;
    return fetchedFixtures;
  }
}
