import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:grouped_list/grouped_list.dart';
import '../models/fixture.dart';
import '../utils/assets.dart';
import '../utils/resources.dart';
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
    return _fixtures.isNotEmpty
        ? GroupedListView(
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
            itemBuilder: (context, fixture) => FixtureTile(
              fixture: fixture,
              key: ValueKey(fixture.fixtureId),
            ),
          )
        : const EmptyList(
            assetImage: Assets.fixturesNotFound,
            message: Resources.fixturesNotFound,
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

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
    required this.assetImage,
    required this.message,
  }) : super(key: key);

  final String assetImage;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(assetImage),
          width: AppSize.s200,
          height: AppSize.s200,
        ),
        const SizedBox(
          height: AppSize.s20,
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
