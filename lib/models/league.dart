import 'package:flutter/material.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/abstract/searchable_tile_element.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/screens/league_details_screen.dart';

class League extends SearchableFavTileElement implements Comparable<League> {
  int leagueId;
  String? type;
  String logo;
  Country? country;
  int? season;
  String? round;

  @override
  String name;

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

  @override
  Widget nextScreen() {
    return LeagueDetailsScreen(league: this);
  }

  @override
  Future addToFavourites() async {
    FirestoreService.addToFavourites(this);
  }

  @override
  Future removeFromFavourites() async {
    FirestoreService.removeFromFavourites(this);
  }

  @override
  List<Widget> buildElements() {
    return [
      Image(
        width: 32,
        height: 32,
        image: NetworkImage(logo),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                country!.name,
                style: const TextStyle(
                  overflow: TextOverflow.fade,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              Text(
                name,
                softWrap: false,
                style: const TextStyle(
                  overflow: TextOverflow.fade,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
