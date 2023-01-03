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
}
