import 'package:flutter/material.dart';
import '../models/fixture.dart';
import 'fixture_tile.dart';

class FixtureList extends StatelessWidget {
  const FixtureList({
    super.key,
    required List<Fixture> fixtures,
  }) : _fixtures = fixtures;

  final List<Fixture> _fixtures;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _fixtures.length,
      itemBuilder: (context, index) {
        final fixture = _fixtures[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FixtureTile(
            fixture: fixture,
            key: ValueKey(fixture.fixtureId),
          ),
        );
      },
    );
  }
}
