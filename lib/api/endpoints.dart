class FootballApiEndpoints {
  static const leaguesByCountryUrl = 'leagues?country=';
  static const countriesUrl = 'countries';
  static const fixturesByLeagueCurrentRoundUrl = 'fixtures?';
  static const standings = 'standings';
  static const leagues = 'leagues';

  static String getFixturesUrl(
    int leagueId,
    int season, {
    bool currentRound = false,
  }) =>
      '${fixturesByLeagueCurrentRoundUrl}league=$leagueId&season=$season';

  static String getStandingsUrl(int leagueId, int season) =>
      '$standings?league=$leagueId&season=$season';
}
