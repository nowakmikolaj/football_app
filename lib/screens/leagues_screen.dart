import 'package:flutter/material.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/providers/leagues_provider.dart';
import '../models/league.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/league_list.dart';

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
  late Future<List<League>> _leagues;

  Future<void> _fetchLeagues() async {
    _leagues = LeaguesProvider.fetchLeagues(widget.country.name.toLowerCase());
    // setState(() => _leagues = leagues);
  }

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        data: 'Leagues',
        icon: Icons.arrow_back_ios,
        backOnTap: true,
      ),
      body: FutureBuilder(
        future: _leagues,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LeagueList(leagues: snapshot.data ?? []);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
