import 'package:football_app/models/team.dart';

class TeamRankData implements Comparable<TeamRankData> {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final int played;
  final int win;
  final int draw;
  final int lose;
  final int goalsFor;
  final int goalsAgainst;
  final String? group;
  final String? form;
  final String? status;
  final String? description;

  TeamRankData({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goalsFor,
    required this.goalsAgainst,
    this.group,
    this.form,
    this.status,
    this.description,
  });

  factory TeamRankData.fromJson(
    Map<String, dynamic> json, {
    required Team team,
  }) {
    return TeamRankData(
      rank: json['rank'],
      team: team,
      points: json['points'],
      goalsDiff: json['goalsDiff'],
      played: json['all']['played'],
      win: json['all']['win'],
      draw: json['all']['draw'],
      lose: json['all']['lose'],
      goalsFor: json['all']['goals']['for'],
      goalsAgainst: json['all']['goals']['against'],
      group: json['group'],
      form: json['form'],
      status: json['status'],
      description: json['description'],
    );
  }

  @override
  int compareTo(TeamRankData other) {
    return rank.compareTo(other.rank);
  }
}
