import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import '../models/fixture.dart';
import 'fixture_tile.dart';

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
    // if (_fixtures.isNotEmpty && _fixtures[0].league.type == 'league') {
    final r1 = round1.replaceAll(RegExp(r'[^0-9]'), '');
    final r2 = round2.replaceAll(RegExp(r'[^0-9]'), '');

    if (r1.isEmpty || r2.isEmpty) {
      return round1.compareTo(round2);
    }

    return int.parse(r1).compareTo(int.parse(r2));
  }

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      elements: _fixtures,
      groupBy: (fixture) => fixture.league.round!,
      order: descending ? GroupedListOrder.DESC : GroupedListOrder.ASC,
      groupComparator: comparator,
      groupSeparatorBuilder: (round) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          round,
          textAlign: TextAlign.center,
        ),
      ),
      itemBuilder: (context, fixture) => FixtureTile(
        fixture: fixture,
        key: ValueKey(fixture.fixtureId),
      ),
    );

    // ListView.builder(
    //   itemCount: _fixtures.length,
    //   itemBuilder: (context, index) {
    //     final fixture = _fixtures[index];
    //     return Padding(
    //       padding: const EdgeInsets.only(top: 8.0),
    //       child: FixtureTile(
    //         fixture: fixture,
    //         key: ValueKey(fixture.fixtureId),
    //       ),
    //     );
    //   },
    // );
  }
}
