import 'package:http/http.dart';

class FootballApi {
  static const apiUrl = "https://api-football-v1.p.rapidapi.com/v3/";

  static const headers = {
    'X-RapidAPI-Key': '8aa68cfb04msh1ed868d9d0dc8b5p1ce766jsna54d37d1a0cc',
    'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com'
  };

  static final leaguesByCountryUrl = Uri.parse('${apiUrl}leagues?country=');
  static final countriesUrl = Uri.parse('${apiUrl}countries');
  static final fixturesByLeagueCurrentRoundUrl =
      Uri.parse('${apiUrl}fixtures?');

  static Uri getFixturesUrl(
    int leagueId,
    int season, {
    bool currentRound = false,
  }) {
    StringBuffer sb = StringBuffer();
    sb.write(
        '${fixturesByLeagueCurrentRoundUrl}league=$leagueId&season=$season');

    if (currentRound) {
      // sb.write('&current=true');
    }

    return Uri.parse(sb.toString());
  }
}
