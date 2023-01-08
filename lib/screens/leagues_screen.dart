import 'package:flutter/material.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/datasources/league_data_source.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_appbar.dart';
import 'package:football_app/widgets/lists/league_list.dart';

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
    _leagues = LeagueDataSource.instance
        .getLeaguesByCountry(widget.country.name);
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
            final data = snapshot.data ?? [];
            data.sort(((a, b) => a.compareTo(b)));
            return LeagueList(leagues: snapshot.data ?? []);
          } else {
            return const CenterIndicator();
          }
        },
      ),
    );
  }
}
