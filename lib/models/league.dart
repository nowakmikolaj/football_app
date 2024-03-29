import 'package:flutter/material.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/models/abstract/searchable_tile_element.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/screens/league_details_screen.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:transparent_image/transparent_image.dart';

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
    FirestoreDataSource.instance.addToFavourites(this);
  }

  @override
  Future removeFromFavourites() async {
    FirestoreDataSource.instance.removeFromFavourites(this);
  }

  @override
  List<Widget> buildElements() {
    return [
      FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: logo,
        width: AppSize.s32,
        height: AppSize.s32,
        fadeInDuration: const Duration(milliseconds: 400),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: AppSize.s20, right: AppSize.s20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                country!.name,
                style: const TextStyle(
                  overflow: TextOverflow.fade,
                  color: Colors.grey,
                  fontSize: FontSize.details,
                ),
              ),
              Text(
                name,
                softWrap: false,
                style: const TextStyle(
                  overflow: TextOverflow.fade,
                  fontWeight: FontWeights.bold,
                  fontSize: FontSize.big,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
