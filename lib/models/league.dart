import 'package:flutter/material.dart';

class League {
  int leagueId;
  String name;
  String type;
  String logo;

  League(
    this.leagueId,
    this.name,
    this.type,
    this.logo,
  );

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      json['id'],
      json['name'],
      json['type'],
      json['logo'],
    );
  }
}
