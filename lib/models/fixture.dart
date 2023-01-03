import 'package:football_app/models/league.dart';
import 'package:football_app/models/match_result.dart';
import 'package:football_app/models/team.dart';

class Fixture implements Comparable<Fixture> {
  int fixtureId;
  String? referee;
  DateTime date;
  String status;
  Team homeTeam;
  Team awayTeam;
  League league;
  MatchResult matchResult;

  Fixture(
    this.fixtureId,
    this.date,
    this.status,
    this.homeTeam,
    this.awayTeam,
    this.league,
    this.matchResult, {
    this.referee,
  });

  factory Fixture.fromJson(
    Map<String, dynamic> json,
    League league,
    Team homeTeam,
    Team awayTeam,
    MatchResult matchResult,
  ) {
    return Fixture(
      json['id'],
      DateTime.parse(json['date']),
      json['status']['short'],
      homeTeam,
      awayTeam,
      league,
      matchResult,
    );
  }

  @override
  int compareTo(other) {
    final res = fixtureId.compareTo(other.fixtureId);

    // if (res == 0) {
    //   return lea.compareTo(other.fixtureId);
    // } else {
    //   return res;
    // }

    return res;
  }
}
