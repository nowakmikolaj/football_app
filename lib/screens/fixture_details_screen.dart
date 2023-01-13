import 'package:flutter/material.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/datasources/football_data_source.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/fixture_event.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_appbar.dart';
import 'package:football_app/widgets/fixture_header.dart';
import 'package:football_app/widgets/lists/event_list.dart';

class FixtureDetailsScreen extends StatefulWidget {
  const FixtureDetailsScreen({super.key, required this.fixture});

  final Fixture fixture;

  @override
  State<FixtureDetailsScreen> createState() => _FixtureDetailsScreenState();
}

class _FixtureDetailsScreenState extends State<FixtureDetailsScreen> {
  late Future<List<Bet>?> _bet;
  late Future<List<FixtureEvent>?> _events;

  Future<void> _getBet() async {
    _bet = FirestoreDataSource.instance.getBet(widget.fixture.fixtureId);
  }

  Future<void> _getEvents() async {
    _events = FootballDataSource.instance.getEvents(widget.fixture);
  }

  @override
  void initState() {
    super.initState();
    _getBet();
    _getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        data:
            "${widget.fixture.homeTeam.name} ${Resources.versus} ${widget.fixture.awayTeam.name}",
        icon: Icons.arrow_back_ios,
        backOnTap: true,
      ),
      body: FutureBuilder(
        future: Future.wait([_bet, _events]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final bet = snapshot.data![0];
            final events = snapshot.data![1];

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  children: [
                    FixtureHeader(
                      fixture: widget.fixture,
                      bet: bet,
                    ),
                    EventList(events: events, fixture: widget.fixture),
                  ],
                ),
              ],
            );
          } else {
            return const CenterIndicator();
          }
        },
      ),
    );
  }
}
