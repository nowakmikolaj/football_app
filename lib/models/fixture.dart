import 'package:football_app/models/league.dart';
import 'package:football_app/models/match_result.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/models/fixture_status.dart';

class Fixture implements Comparable<Fixture> {
  int fixtureId;
  String? referee;
  DateTime date;
  String status;
  Team homeTeam;
  Team awayTeam;
  League league;
  MatchResult matchResult;
  Score goals;

  Fixture(
    this.fixtureId,
    this.date,
    this.status,
    this.homeTeam,
    this.awayTeam,
    this.league,
    this.matchResult,
    this.goals, {
    this.referee,
  });

  factory Fixture.fromJson(
    Map<String, dynamic> json,
    League league,
    Team homeTeam,
    Team awayTeam,
    MatchResult matchResult,
    Score goals,
  ) {
    return Fixture(
      json['id'],
      DateTime.parse(json['date']),
      json['status']['short'],
      homeTeam,
      awayTeam,
      league,
      matchResult,
      goals,
    );
  }

  // ignore: non_constant_identifier_names
  String get Datetime {
    StringBuffer sb = StringBuffer(Date);
    sb.write('\n');
    sb.write(date.hour);
    sb.write(':');
    if (date.minute < 10) {
      sb.write('0');
    }
    sb.write(date.minute);
    return sb.toString();
  }

  // ignore: non_constant_identifier_names
  String get Date {
    StringBuffer sb = StringBuffer();
    if (date.day < 10) {
      sb.write('0');
    }
    sb.write(date.day);
    sb.write('.');
    if (date.month < 10) {
      sb.write('0');
    }
    sb.write(date.month);
    sb.write('.');
    sb.write(date.year);
    return sb.toString();
  }

  FixtureStatus? getStatus() => statusDictionary[status];

  bool isLive() {
    final status = getStatus();
    return status!.index > FixtureStatus.FT.index &&
        status.index <= FixtureStatus.LIVE.index;
  }

  bool isUpcoming() {
    final status = getStatus();

    return status!.index > FixtureStatus.LIVE.index;
  }

  bool isFinished() {
    return getStatus()!.index <= FixtureStatus.FT.index;
  }

  @override
  int compareTo(other) {
    final res = date.compareTo(other.date);
    return res;
  }
}
