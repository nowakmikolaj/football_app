import 'package:flutter/material.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/widgets/tiles/league_tile.dart';

class LeagueList extends StatelessWidget {
  const LeagueList({
    Key? key,
    required List<League> leagues,
  })  : _leagues = leagues,
        super(key: key);

  final List<League> _leagues;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        ...List.generate(
          _leagues.length,
          (index) {
            final league = _leagues[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LeagueTile(
                league: league,
                key: ValueKey(league.leagueId),
              ),
            );
          },
        ),
      ],
    );
  }
}
