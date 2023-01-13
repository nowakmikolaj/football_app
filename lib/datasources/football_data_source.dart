// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:football_app/api/endpoints.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/api/football_service.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/fixture_event.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/models/match_result.dart';
import 'package:football_app/models/player.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/models/standings.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/models/team_rank_data.dart';
import 'package:football_app/utils/messenger_manager.dart';
import 'package:http/http.dart';

class FootballDataSource {
  static final instance = FootballDataSource._();
  FootballDataSource._();

  Future<List<Country>> getCountries() async {
    return FirestoreDataSource.instance.getCountries();
  }

  Future<List<League>> getLeaguesByCountry(String country) async {
    final leagues = FirestoreDataSource.instance.getLeaguesByCountry(country);

    return leagues;
  }

  Future<List<League>> migrateLeagues() async {
    List<League> fetchedLeagues = [];
    try {
      final response = await FootballService.get(
        url: FootballApiEndpoints.leagues,
        headers: FootballService.headers,
      );

      showRemaingRequests(response);

      Map<String, dynamic> res = json.decode(response.body);
      var leagues = res['response'];
      for (int i = 0; i < leagues.length; i++) {
        fetchedLeagues.add(
          League.fromJson(
            leagues[i]['league'],
            country: Country.fromJson(leagues[i]['country']),
          ),
        );
      }

      FirestoreDataSource.instance.migrateLeagues(fetchedLeagues);
    } catch (e) {
      print(e.toString());
    }

    return fetchedLeagues;
  }

  Future<List<Fixture>> getFixturesByLeague({
    required int leagueId,
    int season = 2022,
  }) async {
    List<Fixture> fixtures = [];
    try {
      fixtures = await getFixtures(
        FootballApiEndpoints.getFixturesByCountryUrl(leagueId, season),
      );

      fixtures.sort((a, b) => a.compareTo(b));
    } catch (e) {
      print(e.toString());
    }

    return fixtures;
  }

  Future<List<Fixture>> getFixtures(String url) async {
    List<Fixture> fetchedFixtures = [];
    try {
      final response = await FootballService.get(
        url: url,
        headers: FootballService.headers,
      );

      showRemaingRequests(response);

      Map<String, dynamic> res = json.decode(response.body);
      var fixtures = res['response'];

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
            Score.fromJson(fixtures[i]['goals']),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }

    return fetchedFixtures;
  }

  void showRemaingRequests(Response response) {
    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('Remaining requests: $requestsLeft');
    MessengerManager.showMessageBarWarning('Remaining requests: $requestsLeft');
  }

  Future<Standings> getStandings({
    required int leagueId,
    int season = 2022,
  }) async {
    // return const Standings(standings: []);

    List<List<TeamRankData>> data = [];
    try {
      final response = await FootballService.get(
        url: FootballApiEndpoints.getStandingsUrl(leagueId, season),
        headers: FootballService.headers,
      );

      showRemaingRequests(response);

      Map<String, dynamic> res = json.decode(response.body);
      if (res['response'].length == 0) return const Standings(standings: []);

      var league = res['response'][0]['league'];
      var standings = league['standings'];

      for (int j = 0; j < standings.length; j++) {
        List<TeamRankData> fetchedStandings = [];
        for (int i = 0; i < standings[j].length; i++) {
          fetchedStandings.add(
            TeamRankData.fromJson(standings[j][i],
                team: Team.fromJson(
                  standings[j][i]['team'],
                )),
          );
        }

        data.add(fetchedStandings);
      }
    } catch (e) {
      print(e.toString());
    }
    return Standings(standings: data);
  }

  Future<List<FixtureEvent>> getEvents(Fixture fixture) async {
    if (fixture.isUpcoming()) {
      return [];
    }

    List<FixtureEvent> events = [];
    try {
      final response = await FootballService.get(
        url: FootballApiEndpoints.events + fixture.fixtureId.toString(),
        headers: FootballService.headers,
      );

      showRemaingRequests(response);

      Map<String, dynamic> res = json.decode(response.body);
      var responseData = res['response'];

      for (final eventData in responseData) {
        events.add(FixtureEvent.fromJson(
          eventData,
          Player.fromJson(eventData['player']),
          Player.fromJson(
            eventData['assist'],
          ),
        ));
      }
    } catch (e) {
      print(e.toString());
    }

    return events;
  }
}
