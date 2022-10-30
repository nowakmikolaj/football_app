import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football_app/models/country.dart';

class League {
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
                width: 32,
                height: 32,
              )
            : SvgPicture.network(
                country.flag,
                width: 32,
                height: 32,
              ),
        country);
  }
}
