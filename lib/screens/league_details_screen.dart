import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/datasources/football_data_source.dart';
import 'package:football_app/models/standings.dart';
import 'package:football_app/utils/actions.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_tabbar.dart';
import 'package:football_app/widgets/lists/fixture_list.dart';
import 'package:football_app/widgets/lists/standings_list.dart';

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
  late Future<Standings> _standings;

  Future<void> _getFixtures() async {
    _fixtures = FootballDataSource.instance.getFixturesByLeague(
      leagueId: widget.league.leagueId,
    );
  }

  Future<void> _getStandings() async {
    _standings = FootballDataSource.instance.getStandings(
      leagueId: widget.league.leagueId,
    );
  }

  @override
  void initState() {
    super.initState();
    _getFixtures();
    _getStandings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: const [
              CustomTabBar(name: "Standings"),
              CustomTabBar(name: "Finished"),
              CustomTabBar(name: "Live"),
              CustomTabBar(name: "Upcoming"),
            ],
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image(
                  fit: BoxFit.contain,
                  height: AppSize.s30,
                  width: AppSize.s30,
                  image: NetworkImage(widget.league.logo),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.league.name,
                    style: const TextStyle(
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            getThemeModeAction(context),
          ],
        ),
        body: FutureBuilder(
          future: Future.wait([_fixtures, _standings]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final data = List<Fixture>.from(snapshot.data![0] ?? []);
              data.sort(((a, b) => b.date.compareTo(a.date)));

              final finishedFixtures =
                  data.where((element) => element.isFinished()).toList();

              final upcomingFixtures = List<Fixture>.from(data.reversed)
                  .where((element) => element.isUpcoming())
                  .toList();

              final liveFixtures =
                  data.where((element) => element.isLive()).toList();
              return TabBarView(
                children: [
                  StandingsList(
                    standings: snapshot.data![1],
                  ),
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
