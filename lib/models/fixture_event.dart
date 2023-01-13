import 'package:football_app/models/event_data.dart';
import 'package:football_app/models/player.dart';

class FixtureEvent {
  int elapsed;
  int? extra;
  int teamId;
  Player player;
  Player assist;
  String type;
  String detail;

  FixtureEvent({
    required this.elapsed,
    required this.extra,
    required this.teamId,
    required this.type,
    required this.detail,
    required this.player,
    required this.assist,
  });

  factory FixtureEvent.fromJson(
    Map<String, dynamic> json,
    Player player,
    Player assist,
  ) {
    return FixtureEvent(
      elapsed: json['time']['elapsed'],
      extra: json['time']['extra'],
      teamId: json['team']['id'],
      type: json['type'],
      detail: json['detail'],
      player: player,
      assist: assist,
    );
  }

  bool isFirstHalf() => elapsed <= 45;

  bool isSecondHalf() => !isFirstHalf() && elapsed <= 90;

  bool isExtraTime() =>
      !isFirstHalf() && !isSecondHalf() && !isPenaltyShootout();

  bool isPenaltyShootout() => elapsed == 120 && extra != null;

  EventData mapToEventData() {
    switch (detail.toLowerCase()) {
      case EventTypes.normalGoal:
        return NormalGoal(this);

      case EventTypes.ownGoal:
        return OwnGoal(this);

      case EventTypes.penalty:
        return PenaltyGoal(this);

      case EventTypes.missedPenalty:
        return MissedPenalty(this);

      case EventTypes.yellowCard:
        return YellowCard(this);

      case EventTypes.secondYellowCard:
        return SecondYellowCard(this);

      case EventTypes.redCard:
        return RedCard(this);
    }

    if (detail.toLowerCase().contains(EventTypes.substitution)) {
      return Substitution(this);
    }

    return Var(this);
  }
}
