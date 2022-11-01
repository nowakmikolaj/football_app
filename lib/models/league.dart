import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football_app/models/country.dart';

class League implements Comparable<League> {
  int leagueId;
  String name;
  String type;
  Widget logo;
  Country? country;

  League(this.leagueId, this.name, this.type, this.logo, this.country);

  factory League.fromJson(Map<String, dynamic> json, Country country) {
    return League(
        json['id'],
        json['name'],
        json['type'],
        country.flag == ''
            ? Image.network(
                json['logo'],
              )
            : SvgPicture.network(
                country.flag,
              ),
        country);
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
