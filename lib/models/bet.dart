import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/score.dart';

class Bet implements Comparable<Bet> {
  Fixture? fixture;
  Score? goals;
  int? points;
  String? userId;
  DateTime? timestamp;

  Bet({this.fixture, this.goals, this.userId, this.points, this.timestamp});

  void placeBet() {
    FirestoreDataSource.instance.placeBet(this);
  }

  factory Bet.fromJson({
    required Map<String, dynamic> json,
    Fixture? fixture,
  }) {
    return Bet(
      fixture: fixture,
      goals: Score.fromJson(json),
      points: json['points'],
      userId: json['userId'],
      timestamp: DateTime.parse(json['timestamp'].toDate().toString()),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      "id": fixture!.fixtureId,
      "home": goals!.home!,
      "away": goals!.away!,
      "userId": userId,
      "timestamp": DateTime.now(),
      "points": points,
      "fixture":
          FirebaseFirestore.instance.doc("fixtures/${fixture!.fixtureId}"),
    };
  }

  bool settle() {
    if (goals == null ||
        goals!.home == null ||
        goals!.away == null ||
        fixture == null ||
        fixture!.goals.home == null ||
        fixture!.goals.away == null) {
      return false;
    }

    points = goals!.compareTo(fixture!.goals);

    return points != null;
  }

  @override
  int compareTo(Bet other) {
    if (timestamp == null || other.timestamp == null) {
      return -1;
    }
    return other.timestamp!.compareTo(timestamp!);
  }
}
