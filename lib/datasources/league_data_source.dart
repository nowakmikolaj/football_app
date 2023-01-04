import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_app/api/football_client.dart';

import '../api/endpoints.dart';
import '../models/country.dart';
import '../models/fixture.dart';
import '../models/league.dart';
import '../models/match_result.dart';
import '../models/score.dart';
import '../models/team.dart';

class LeagueDataSource {
  static final instance = LeagueDataSource._();
  LeagueDataSource._();

  Future<List<League>> getLeaguesByCountry(String country) async {
    final response = await FootballClient.get(
      url: '${Endpoints.leaguesByCountryUrl}$country',
      headers: FootballClient.headers,
    );
    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('[leagues] Remaining requests: ${requestsLeft}');

    Map<String, dynamic> res = json.decode(response.body);
    var leagues = res['response'];
    List<League> fetchedLeagues = [];
    for (int i = 0; i < leagues.length; i++) {
      fetchedLeagues.add(
        League.fromJson(
          leagues[i]['league'],
          country: Country.fromJson(leagues[i]['country']),
        ),
      );
    }

    fetchedLeagues.sort((a, b) => a.compareTo(b));

    return fetchedLeagues;
  }

  Future<List<Fixture>> getFixturesByLeague({
    required int leagueId,
    int season = 2022,
  }) async {
    final response = await FootballClient.get(
      url: Endpoints.getFixturesUrl(leagueId, season),
      headers: FootballClient.headers,
    );

    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('[fixtures] Remaining requests: $requestsLeft');

    Map<String, dynamic> res = json.decode(response.body);
    var fixtures = res['response'];

    List<Fixture> fetchedFixtures = [];
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
    return fetchedFixtures;
  }
}