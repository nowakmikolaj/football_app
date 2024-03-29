import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/utils/actions.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_tabbar.dart';
import 'package:football_app/widgets/lists/bets_list.dart';
import 'package:football_app/widgets/lists/ranking_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Bet>> _bets;

  Future<void> _getBets() async {
    _bets = FirestoreDataSource.instance.getBets();
  }

  static const List<Widget> _tabs = [
    CustomTabBar(name: Resources.tabBarBets),
    CustomTabBar(name: Resources.ranking),
    CustomTabBar(name: Resources.challenge),
  ];

  @override
  void initState() {
    super.initState();
    _getBets();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _tabs,
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: const Icon(Icons.account_circle_rounded),
          title: Text(
            user.email!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.appBarTitle,
            ),
          ),
          actions: [
            getThemeModeAction(context),
            getActionSignOut(),
          ],
        ),
        body: Center(
          child: FutureBuilder(
              future: _bets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final bets = snapshot.data ?? [];

                  final userBets = bets
                      .where((element) =>
                          element.userId!.toLowerCase() ==
                          FirebaseAuth.instance.currentUser!.email!
                              .toLowerCase())
                      .toList();

                  var challengeBets = [...bets];

                  final userFixtures = userBets.map((e) => e.fixture).toList();

                  challengeBets.removeWhere(
                      (element) => userFixtures.contains(element.fixture));
                  challengeBets.removeWhere(
                    (element) => !element.fixture!.isUpcoming(),
                  );
                  challengeBets = challengeBets.toSet().toList();

                  return TabBarView(
                    children: [
                      BetsList(
                        headerText: Resources.betsHistory,
                        bets: userBets,
                      ),
                      RankingList(bets: bets),
                      BetsList(
                        headerText: Resources.betsChallengeHeader,
                        bets: challengeBets,
                      ),
                    ],
                  );
                } else {
                  return const CenterIndicator();
                }
              }),
        ),
      ),
    );
  }
}
