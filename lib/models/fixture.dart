import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/models/match_result.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/models/fixture_status.dart';
import 'package:football_app/screens/fixture_details_screen.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/team_info.dart';

class Fixture extends TileElement implements Comparable<Fixture> {
  int fixtureId;
  String? referee;
  DateTime date;
  String status;
  Team homeTeam;
  Team awayTeam;
  League league;
  MatchResult? matchResult;
  Score goals;

  Fixture(
    this.fixtureId,
    this.date,
    this.status,
    this.homeTeam,
    this.awayTeam,
    this.league,
    this.goals, {
    this.matchResult,
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
      goals,
      matchResult: matchResult,
    );
  }

  factory Fixture.fromFirebase({
    required Map<String, dynamic> json,
    required League league,
    required Team homeTeam,
    required Team awayTeam,
    required Score goals,
  }) {
    return Fixture(
      json['id'],
      DateTime.parse(json['date'].toDate().toString()),
      json['status'],
      homeTeam,
      awayTeam,
      league,
      goals,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      "id": fixtureId,
      "date": date,
      "status": status,
      "homeTeamId": FirebaseFirestore.instance.doc("teams/${homeTeam.teamId}"),
      "awayTeamId": FirebaseFirestore.instance.doc("teams/${awayTeam.teamId}"),
      "league": FirebaseFirestore.instance.doc("leagues/${league.leagueId}"),
      "home": goals.home,
      "away": goals.away,
    };
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

  @override
  List<Widget> buildElements() {
    return [
      TeamInfo(
        team: homeTeam,
      ),
      (getStatus() == FixtureStatus.NS)
          ? Expanded(
              child: Column(
                children: [
                  Text(
                    Datetime,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Expanded(
              child: Column(
                children: [
                  !isLive()
                      ? Column(
                          children: [
                            Text(
                              Date,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        goals.home != null ? goals.home.toString() : '',
                        style: const TextStyle(fontSize: FontSize.title),
                      ),
                      !isUpcoming()
                          ? const Text(
                              ":",
                              style: TextStyle(fontSize: FontSize.title),
                            )
                          : Container(),
                      Text(
                        goals.away != null ? goals.away.toString() : '',
                        style: const TextStyle(fontSize: FontSize.title),
                      )
                    ],
                  ),
                  const SizedBox(height: AppSize.s2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p15,
                      vertical: AppPadding.p2,
                    ),
                    decoration: BoxDecoration(
                      color: getStatus() != FixtureStatus.FT
                          ? Colors.red
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(AppSize.s20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: FontSize.paragraph,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
      TeamInfo(
        team: awayTeam,
      ),
    ];
  }

  @override
  Widget nextScreen() {
    return FixtureDetailsScreen(fixture: this);
  }
}
