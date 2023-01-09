import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/screens/leagues_screen.dart';
import 'package:football_app/utils/app_size.dart';

class Country extends TileElement implements Comparable<Country> {
  String name;
  String? code;
  String flag;

  Country(
    this.name,
    this.code,
    this.flag,
  );

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      json['name'],
      json['code'],
      json['flag'] ?? '',
    );
  }

  // TODO: wywalić
  static List<String> topCountries = [
    'England',
    'Spain',
    'Germany',
    'Italy',
    'France',
    'Poland',
    'World',
  ];

  Map<String, String?> toFirestore() {
    return <String, String?>{
      "name": name,
      "flag": flag,
      "code": code,
    };
  }

  @override
  int compareTo(Country other) {
    if (topCountries.contains(name)) {
      if (topCountries.contains(other.name)) {
        return name.compareTo(other.name);
      }
      return -1;
    }

    if (topCountries.contains(other.name)) return 1;

    return name.compareTo(other.name);
  }

  @override
  List<Widget> buildElements() {
    return [
      SizedBox(
        width: 32,
        height: 32,
        child: flag.isNotEmpty ? SvgPicture.network(flag) : Container(),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                name.toUpperCase(),
                softWrap: false,
                style: const TextStyle(
                  overflow: TextOverflow.fade,
                  fontWeight: FontWeights.semiBold,
                  fontSize: FontSize.subTitle,
                ),
              ),
            ],
          ),
        ),
      ),
      const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
    ];
  }

  @override
  Widget nextScreen() {
    return LeaguesScreen(country: this);
  }
}
