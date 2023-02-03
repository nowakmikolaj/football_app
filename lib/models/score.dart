class Score {
  int? home;
  int? away;

  Score({
    this.home,
    this.away,
  });

  factory Score.fromJson(
    Map<String, dynamic> json,
  ) {
    return Score(
      home: json['home'],
      away: json['away'],
    );
  }

  int compareTo(Score other) {
    if (home! == other.home! && away! == other.away!) {
      return BetResult.correct;
    } else if (home! - away! == other.home! - other.away!) {
      return BetResult.goalDifferenceCorrect;
    } else if (home! > away! && other.home! > other.away! ||
        home! < away! && other.home! < other.away!) {
      return BetResult.winnerCorrect;
    } else if (home! + away! + other.home! + other.away! == 0 ||
        home! > 0 && away! > 0 && other.home! > 0 && other.away! > 0) {
      return BetResult.bothTeamToScoreCorrect;
    } else if (home! == other.home! && away! != other.away! ||
        away! == other.away! && home! != other.home!) {
      return BetResult.oneTeamGoalsCorrect;
    } else if (away! == other.away!) {
      return BetResult.oneTeamGoalsCorrect;
    }

    return BetResult.incorrect;
  }
}

class BetResult {
  static const correct = 5;
  static const goalDifferenceCorrect = 3;
  static const winnerCorrect = 2;
  static const bothTeamToScoreCorrect = 1;
  static const oneTeamGoalsCorrect = 0;
  static const incorrect = -2;
}
