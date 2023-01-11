import 'package:flutter/material.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/lists/empty_list.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/screens/league_details_screen.dart';
import 'package:football_app/screens/leagues_screen.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/models/abstract/searchable_tile_element.dart';
import 'package:football_app/widgets/tiles/tile.dart';

class MySearchDelegate extends SearchDelegate<Future<Widget>?> {
  MySearchDelegate() {
    _getData();
  }

  late Future<List<SearchableTileElement>> searchData;
  late SearchableTileElement selectedItem;

  @override
  String get searchFieldLabel => Resources.searchFieldLabel;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (selectedItem is Country) {
      return LeaguesScreen(countryName: selectedItem.name);
    } else if (selectedItem is League) {
      return LeagueDetailsScreen(league: selectedItem as League);
    } else {
      return const EmptyList(
        assetImage: Assets.search,
        message: Resources.searchError,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const EmptyList(
        assetImage: Assets.search,
        message: Resources.searchStart,
      );
    }
    return FutureBuilder(
        future: searchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final data = snapshot.data!
                .where((element) =>
                    element.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

            if (data.isEmpty) {
              return const EmptyList(
                assetImage: Assets.search,
                message: Resources.searchResultEmpty,
              );
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final suggestion = data[index];
                return GestureDetector(
                  onTap: () => selectedItem = suggestion,
                  child: Tile(tileData: suggestion),
                );
              },
            );
          } else {
            return const CenterIndicator();
          }
        });
  }

  Future<List<TileElement>> _getData() async {
    searchData = FirestoreService.getSearchData();
    return searchData;
  }
}
