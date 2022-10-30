import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:football_app/providers/leagues_provider.dart';
import 'package:football_app/widgets/league_tile.dart';

import '../models/league.dart';

class FixtureScreen extends StatefulWidget {
  const FixtureScreen({super.key});

  @override
  State<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends State<FixtureScreen> {
  List<League> _leagues = [];

  Future<void> _fetchLeagues() async {
    final leagues = await LeaguesProvider.fetchLeagues();
    setState(() => _leagues = leagues);
  }

  @override
  void initState() {
    super.initState();
    LeaguesProvider.fetchLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 40,
          centerTitle: true,
          leading: const Icon(Icons.calendar_month),
          title: const Text(
            'Fixtures',
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            tabs: const <BarTab>[
              BarTab(date: "27.10"),
              BarTab(date: "28.10"),
              BarTab(date: "29.10"),
              BarTab(date: "today"),
              BarTab(date: "31.10"),
              BarTab(date: "01.11"),
              BarTab(date: "02.11"),
            ],
          ),
        ),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
            PointerDeviceKind.stylus,
          }),
          child: RefreshIndicator(
            onRefresh: _fetchLeagues,
            child: ListView.builder(
              itemCount: _leagues.length,
              itemBuilder: (context, index) {
                final league = _leagues[index];
                return LeagueTile(
                  league: league,
                  key: ValueKey(league.leagueId),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LeagueListBuilder extends StatelessWidget {
  const LeagueListBuilder({
    Key? key,
    required this.leagues,
  }) : super(key: key);

  final List<League>? leagues;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...leagues!.map(
          (e) => LeagueTile(league: e),
        ),
      ],
    );
  }
}

class BarTab extends StatelessWidget {
  const BarTab({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(date),
    );
  }
}
