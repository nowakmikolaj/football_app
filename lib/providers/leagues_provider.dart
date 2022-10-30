import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_app/providers/FootballApi.dart';
import 'package:http/http.dart' as http;

import '../models/league.dart';

class LeaguesProvider {
  Future<List<League>> fetchLeagues() async {
    http.Response response = await http.get(
      FootballApi.leaguesUrl,
      headers: FootballApi.headers,
    );

    Map<String, dynamic> res = json.decode(response.body);
    var leagues = res['response'];
    List<League> fetchedLeagues = [];

    print('Api services: ${res}');

    for (int i = 0; i < leagues.length; i++) {
      fetchedLeagues.add(League.fromJson(leagues[i]['league']));
    }
    return fetchedLeagues;
  }
}
