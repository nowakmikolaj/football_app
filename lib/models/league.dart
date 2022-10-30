import 'package:flutter/material.dart';

class League {
  int leagueID;
  String name;
  String type;
  String country;
  String countryCode;
  int season;
  String seasonStart;
  String seasonEnd;
  String logo;
  String flag;
  int standings;
  int isCurrent;

  League({
    required this.leagueID,
    required this.name,
    required this.type,
    required this.country,
    required this.countryCode,
    required this.season,
    required this.seasonStart,
    required this.seasonEnd,
    required this.logo,
    required this.flag,
    required this.standings,
    required this.isCurrent,
  });
}
