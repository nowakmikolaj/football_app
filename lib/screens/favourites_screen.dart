import 'package:flutter/material.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/utils/actions.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_tabbar.dart';
import 'package:football_app/widgets/lists/empty_list.dart';
import 'package:football_app/widgets/lists/league_list.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late Future<List<League>> _favLeagues;

  Future<void> _getFavouriteLeagues() async {
    _favLeagues = FirestoreDataSource.instance.getFavouriteLeagues();
  }

  @override
  void initState() {
    super.initState();
    _getFavouriteLeagues();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: const [
              CustomTabBar(name: "Leagues"),
              CustomTabBar(name: "Teams"),
            ],
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: const Icon(Icons.star_rounded),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Favourites",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
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
          future: _favLeagues,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<League> favouriteLeagues = snapshot.data as List<League>;
              favouriteLeagues.sort((a, b) => a.compareTo(b));

              return TabBarView(
                children: [
                  favouriteLeagues.isEmpty
                      ? const EmptyList(
                          assetImage: Assets.noFavourites,
                          message: Resources.noFavouritesLeaguesMessage)
                      : LeagueList(leagues: favouriteLeagues),
                  const EmptyList(
                      assetImage: Assets.supporter, message: "Coming soon..."),
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
