import 'package:football_app/models/country.dart';

class League implements Comparable<League> {
  int leagueId;
  String name;
  String type;
  String logo;
  Country? country;

  League(
    this.leagueId,
    this.name,
    this.type,
    this.logo,
    this.country,
  );

  factory League.fromJson(
    Map<String, dynamic> json,
    Country country,
  ) {
    return League(
      json['id'],
      json['name'],
      json['type'],
      json['logo'],
      country,
    );
  }

  @override
  int compareTo(other) {
    final res = country!.name.compareTo(other.country!.name);

    if (res == 0) {
      return leagueId.compareTo(other.leagueId);
    } else {
      return res;
    }
  }
}
