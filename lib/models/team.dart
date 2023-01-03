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

  @override
  int compareTo(Team other) {
    return name.compareTo(other.name);
  }
}
