import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/datasources/league_data_source.dart';
import 'package:football_app/utils/fixture_status.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_tabbar.dart';

import '../widgets/fixture_list.dart';

class LeagueDetailsScreen extends StatefulWidget {
  const LeagueDetailsScreen({
    super.key,
    required this.league,
  });

  final League league;

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen> {
  late Future<List<Fixture>> _fixtures;

  Future<void> _getFixtures() async {
    _fixtures = LeagueDataSource.instance.getFixturesByLeague(
      leagueId: widget.league.leagueId,
    );
  }

  @override
  void initState() {
    super.initState();
    _getFixtures();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              CustomTabBar(name: "Standings"),
              CustomTabBar(name: "Finished"),
              CustomTabBar(name: "Live"),
              CustomTabBar(name: "Upcoming"),
            ],
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            widget.league.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _fixtures,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = List<Fixture>.from(snapshot.data ?? []);
              data.sort(((a, b) => b.date.compareTo(a.date)));

              final finishedFixtures =
                  data.where((element) => isFinished(element)).toList();
              // element.date.isBefore(
              //  DateTime.now().subtract(const Duration(days: 1))))

              final upcomingFixtures = List<Fixture>.from(data.reversed)
                  .where((element) =>
                      element.date.isAfter(
                          DateTime.now().subtract(const Duration(days: 1))) &&
                      isUpcoming(element))
                  .toList();

              final liveFixtures =
                  data.where((element) => isLive(element)).toList();
              return TabBarView(
                children: [
                  // TODO: Standings
                  Container(),
                  FixtureList(
                    fixtures: finishedFixtures,
                    descending: true,
                  ),
                  FixtureList(
                    fixtures: liveFixtures,
                  ),
                  FixtureList(
                    fixtures: upcomingFixtures,
                  ),
                ],
              );
            } else {
              return const CenterIndicator();
            }
          },
        ),
      ),
    );
  }
}
