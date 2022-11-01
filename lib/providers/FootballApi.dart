import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FootballApi {
  static const apiUrl = "https://api-football-v1.p.rapidapi.com/v3/";

  static const headers = {
    'X-RapidAPI-Key': '8aa68cfb04msh1ed868d9d0dc8b5p1ce766jsna54d37d1a0cc',
    'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com'
  };

  static final leaguesUrl = Uri.parse('${apiUrl}leagues');
  static final countriesUrl = Uri.parse('${apiUrl}countries');
}
