import 'dart:convert';
import 'package:football_app/api/endpoints.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/api/football_service.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/models/match_result.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/models/standings.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/models/team_rank.dart';

class LeagueDataSource {
  static final instance = LeagueDataSource._();
  LeagueDataSource._();

  Future<List<League>> getLeaguesByCountry(String country) async {
    final leagues = FirestoreService.getLeaguesByCountry(country);

    return leagues;
  }

  Future<List<League>> migrateLeagues() async {
    final response = await FootballService.get(
      url: FootballApiEndpoints.leagues,
      headers: FootballService.headers,
    );
    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('[leagues] Remaining requests: $requestsLeft');

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

    FirestoreService.migrateLeagues(fetchedLeagues);

    return fetchedLeagues;
  }

  Future<List<Fixture>> getFixturesByLeague({
    required int leagueId,
    int season = 2022,
  }) async {
    final response = await FootballService.get(
      url: FootballApiEndpoints.getFixturesUrl(leagueId, season),
      headers: FootballService.headers,
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
          Score.fromJson(fixtures[i]['goals']),
        ),
      );
    }

    fetchedFixtures.sort((a, b) => a.compareTo(b));
    return fetchedFixtures;
  }

  Future<Standings> getStandings({
    required int leagueId,
    int season = 2022,
  }) async {
    final response = await FootballService.get(
      url: FootballApiEndpoints.getStandingsUrl(leagueId, season),
      headers: FootballService.headers,
    );
    var requestsLeft = response.headers['x-ratelimit-requests-remaining'];
    print('[standings] Remaining requests: $requestsLeft');

    Map<String, dynamic> res = json.decode(response.body);
    if (res['response'].length == 0) return const Standings(standings: []);

    var league = res['response'][0]['league'];
    var standings = league['standings'];

    List<List<TeamRank>> data = [];
    for (int j = 0; j < standings.length; j++) {
      List<TeamRank> fetchedStandings = [];
      for (int i = 0; i < standings[j].length; i++) {
        fetchedStandings.add(
          TeamRank.fromJson(standings[j][i],
              team: Team.fromJson(
                standings[j][i]['team'],
              )),
        );
      }

      data.add(fetchedStandings);
    }
    return Standings(standings: data);
  }
}
