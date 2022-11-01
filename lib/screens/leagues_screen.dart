import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/providers/leagues_provider.dart';
import 'package:football_app/widgets/league_tile.dart';

import '../models/league.dart';
import '../utils/utils.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({
    super.key,
    required this.country,
  });

  final Country country;

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  List<League> _leagues = [];

  Future<void> _fetchLeagues() async {
    final leagues = await LeaguesProvider.fetchLeagues();
    setState(() => _leagues = leagues);
  }

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return LeaguesProvider(
      leagues: _leagues,
      child: Scaffold(
        appBar: Utils.createAppBar('Leagues', Icons.arrow_back_ios),
        body: LeagueList(leagues: _leagues),
      ),
    );
  }
}

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
