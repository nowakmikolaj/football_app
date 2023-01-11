class Team implements Comparable<Team> {
  int teamId;
  String name;
  String logo;
  bool? winner;

  Team(
    this.teamId,
    this.name,
    this.logo,
    this.winner,
  );

  factory Team.fromJson(
    Map<String, dynamic> json,
  ) {
    return Team(
      json['id'],
      json['name'],
      json['logo'],
      json['winner'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      "id": teamId,
      "name": name,
      "logo": logo,
      "winner": winner,
    };
  }

  bool isWinner() {
    return winner != null && winner!;
  }

  @override
  int compareTo(Team other) {
    return name.compareTo(other.name);
  }
}
