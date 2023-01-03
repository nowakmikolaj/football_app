import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';

class FixtureTile extends StatefulWidget {
  const FixtureTile({
    super.key,
    required this.fixture,
  });

  final Fixture fixture;

  @override
  State<FixtureTile> createState() => _FixtureTileState();
}

class _FixtureTileState extends State<FixtureTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
