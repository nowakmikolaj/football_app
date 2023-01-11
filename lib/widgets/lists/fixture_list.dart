import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/lists/empty_list.dart';
import 'package:football_app/widgets/tiles/tile.dart';
import 'package:grouped_list/grouped_list.dart';

// TODO: zrobić pobieranie rund dla ligi i zmiana groupcomparera na podstawie indeksów w liście rund
class FixtureList extends StatelessWidget {
  const FixtureList({
    super.key,
    required List<Fixture> fixtures,
    this.descending = false,
  }) : _fixtures = fixtures;

  final List<Fixture> _fixtures;
  final bool descending;

  int comparator(String round1, String round2) {
    final r1 = round1.replaceAll(RegExp(r'[^0-9]'), '');
    final r2 = round2.replaceAll(RegExp(r'[^0-9]'), '');

    if (r1.isEmpty || r2.isEmpty) {
      return round1.compareTo(round2);
    }

    return int.parse(r1).compareTo(int.parse(r2));
  }

  @override
  Widget build(BuildContext context) {
    return _fixtures.isNotEmpty
        ? GroupedListView(
            physics: const BouncingScrollPhysics(),
            elements: _fixtures,
            groupBy: (fixture) => fixture.league.round!,
            order: descending ? GroupedListOrder.DESC : GroupedListOrder.ASC,
            groupComparator: comparator,
            itemComparator: (element1, element2) =>
                element1.compareTo(element2),
            groupSeparatorBuilder: (round) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                round,
                textAlign: TextAlign.center,
              ),
            ),
            itemBuilder: (context, fixture) => Tile<Fixture>(
              tileData: fixture,
              key: ValueKey(fixture.fixtureId),
            ),
          )
        : const EmptyList(
            assetImage: Assets.fixturesNotFound,
            message: Resources.fixturesNotFound,
          );
  }
}