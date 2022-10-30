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
  final LeaguesProvider _leaguesProvider = LeaguesProvider();

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
        body: FutureBuilder(
          future: _leaguesProvider.fetchLeagues(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              print((snapshot.data)?.length);
              return LeagueListBuilder(leagues: snapshot.data);
            } else {
              return const Center();
            }
          }),
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
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: leagues?.length,
        itemBuilder: (context, i) => LeagueTile(
          key: ValueKey(leagues![i].leagueId),
          league: leagues![i],
        ),
      ),

      // SizedBox(
      //   height: 1500,
      //   child: TabBarView(
      //     children: [
      //       Column(

      //       ),
      //     ],
      //   ),
      // ),
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
