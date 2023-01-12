import 'package:flutter/material.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/messenger_manager.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/lists/empty_list.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/screens/league_details_screen.dart';
import 'package:football_app/screens/leagues_screen.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/models/abstract/searchable_tile_element.dart';
import 'package:football_app/widgets/tiles/tile.dart';
import 'package:grouped_list/grouped_list.dart';

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
    MessengerManager.showMessageBarInfo(selectedItem.runtimeType.toString());
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

            return GroupedListView(
              physics: const BouncingScrollPhysics(),
              elements: data,
              groupBy: (element) => element.runtimeType.toString(),
              groupSeparatorBuilder: (type) => Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p20,
                  bottom: AppPadding.p5,
                  left: AppPadding.p20,
                ),
                child: Text(
                  type.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: FontSize.subTitle),
                ),
              ),
              itemBuilder: (context, element) => GestureDetector(
                onTap: () => selectedItem = element,
                child: Tile(tileData: element),
              ),
            );
          } else {
            return const CenterIndicator();
          }
        });
  }

  Future<List<TileElement>> _getData() async {
    searchData = FirestoreDataSource.instance.getSearchData();
    return searchData;
  }
}
