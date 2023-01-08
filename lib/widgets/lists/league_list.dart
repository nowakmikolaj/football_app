import 'package:flutter/material.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/tiles/league_tile.dart';

class LeagueList extends StatefulWidget {
  const LeagueList({
    Key? key,
    required List<League> leagues,
  })  : _leagues = leagues,
        super(key: key);

  final List<League> _leagues;

  @override
  State<LeagueList> createState() => _LeagueListState();
}

class _LeagueListState extends State<LeagueList> {
  late Future<List> _favIds;

  Future<void> _favouriteCheck() async {
    _favIds = FirestoreService.getFavouriteLeagueIds();
  }

  @override
  void initState() {
    super.initState();
    _favouriteCheck();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _favIds,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final favIds = snapshot.data ?? [];
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ...List.generate(
                widget._leagues.length,
                (index) {
                  final league = widget._leagues[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LeagueTile(
                      league: league,
                      isFav: favIds.contains(league.leagueId),
                      key: ValueKey(league.leagueId),
                    ),
                  );
                },
              ),
            ],
          );
        } else {
          return const CenterIndicator();
        }
      },
    );
  }
}
