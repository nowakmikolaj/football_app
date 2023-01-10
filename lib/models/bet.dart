import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/score.dart';

class Bet {
  Fixture? fixture;
  Score? goals;
  int? points;
  String? userId;

  Bet({
    this.fixture,
    this.goals,
    this.userId,
    this.points,
  });

  void placeBet() {
    FirestoreService.placeBet(this);
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      "id": fixture!.fixtureId,
      "home": goals!.home!,
      "away": goals!.away!,
      "userId": userId,
      "timestamp": DateTime.now()
    };
  }
}
