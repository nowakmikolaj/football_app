import 'package:football_app/models/fixture_event.dart';
import 'package:football_app/utils/assets.dart';

class EventTypes {
  static const normalGoal = "normal goal";
  static const ownGoal = "own goal";
  static const penalty = "penalty";
  static const missedPenalty = "missed penalty";
  static const yellowCard = "yellow card";
  static const secondYellowCard = "second yellow card";
  static const redCard = "red card";
  static const substitution = "substitution";
  static const goalCancelled = "goal disallowed";
  static const penaltyConfirmed = "penalty confirmed";
}

abstract class EventData {
  final FixtureEvent event;

  EventData({required this.event});

  String getText();
  String getIconAsset();
}

abstract class Goal extends EventData {
  Goal(FixtureEvent event) : super(event: event);

  @override
  String getText() => "${event.player.name}";
}

class NormalGoal extends Goal {
  NormalGoal(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.goal;

  @override
  String getText() {
    if (event.assist.name == null) return super.getText();
    return super.getText() + "\n(${event.assist.name})";
  }
}

class OwnGoal extends Goal {
  OwnGoal(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.ownGoal;
}

class PenaltyGoal extends Goal {
  PenaltyGoal(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.penalty;
}

class MissedPenalty extends Goal {
  MissedPenalty(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.penaltyMissed;
}

abstract class Card extends EventData {
  Card(FixtureEvent event) : super(event: event);

  @override
  String getText() => "${event.player.name}";
}

class YellowCard extends Card {
  YellowCard(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.yellowCard;
}

class SecondYellowCard extends Card {
  SecondYellowCard(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.secondYellowCard;
}

class RedCard extends Card {
  RedCard(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.redCard;
}

class Substitution extends EventData {
  Substitution(FixtureEvent event) : super(event: event);

  @override
  String getIconAsset() => Assets.subst;

  @override
  String getText() => "${event.player.name}\n(${event.assist.name})";
}

abstract class Var extends EventData {
  Var(FixtureEvent event) : super(event: event);

  @override
  String getText() => "VAR - ${event.detail}";
}

class VarCancelled extends Var {
  VarCancelled(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.VAR;
}

class VarConfirmed extends Var {
  VarConfirmed(FixtureEvent event) : super(event);

  @override
  String getIconAsset() => Assets.VAR;
}