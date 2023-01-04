class Endpoints {
  
  static const leaguesByCountryUrl = 'leagues?country=';
  static const countriesUrl = 'countries';
  static const fixturesByLeagueCurrentRoundUrl =
      'fixtures?';

  static String getFixturesUrl(
    int leagueId,
    int season, {
    bool currentRound = false,
  }) {
    StringBuffer sb = StringBuffer();
    sb.write(
        '${fixturesByLeagueCurrentRoundUrl}league=$leagueId&season=$season');

    return sb.toString();
  }
}