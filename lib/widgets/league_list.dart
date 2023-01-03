import 'package:flutter/material.dart';
import '../models/league.dart';
import 'league_tile.dart';

class LeagueList extends StatelessWidget {
  const LeagueList({
    Key? key,
    required List<League> leagues,
  })  : _leagues = leagues,
        super(key: key);

  final List<League> _leagues;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _leagues.length,
      itemBuilder: (context, index) {
        final league = _leagues[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LeagueTile(
            league: league,
            key: ValueKey(league.leagueId),
          ),
        );
      },
    );
  }
}
