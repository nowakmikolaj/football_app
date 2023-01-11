class FootballApiEndpoints {
  static const leaguesByCountryUrl = 'leagues?country=';
  static const countriesUrl = 'countries';
  static const fixturesUrl = 'fixtures?';
  static const standings = 'standings';
  static const leagues = 'leagues';

  static String getFixturesByCountryUrl(
    int leagueId,
    int season, {
    bool currentRound = false,
  }) =>
      '${fixturesUrl}league=$leagueId&season=$season';

  static String getFixturesByIdsUrl(
    List<int> ids,
  ) {
    StringBuffer sb = StringBuffer();

    for (int k = 0; k < ids.length - 1; k++) {
      sb.write(ids[k]);
      sb.write('-');
    }
    sb.write(ids.last);

    return '${fixturesUrl}ids=${sb.toString()}';
  }

  static String getStandingsUrl(int leagueId, int season) =>
      '$standings?league=$leagueId&season=$season';
}
