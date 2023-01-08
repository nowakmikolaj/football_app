import 'package:football_app/models/country.dart';

class League implements Comparable<League> {
  int leagueId;
  String name;
  String? type;
  String logo;
  Country? country;
  int? season;
  String? round;

  League(
    this.leagueId,
    this.name,
    this.logo, {
    this.type,
    this.country,
    this.season = 0,
    this.round = '',
  });

  factory League.fromJson(
    Map<String, dynamic> json, {
    Country? country,
  }) {
    return League(
      json['id'],
      json['name'],
      json['logo'],
      type: json['type'],
      round: json['round'],
      season: json['season'],
      country: country,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      "id": leagueId,
      "name": name,
      "country": country!.name,
      "type": type,
      "logo": logo,
    };
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
