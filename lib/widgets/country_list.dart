import 'package:flutter/material.dart';
import '../models/country.dart';
import 'country_tile.dart';

class CountryList extends StatelessWidget {
  const CountryList({
    Key? key,
    required List<Country> countries,
  })  : _countries = countries,
        super(key: key);

  final List<Country> _countries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _countries.length,
      itemBuilder: (context, index) {
        final country = _countries[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CountryTile(
            country: country,
            key: ValueKey(country.name),
          ),
        );
      },
    );
  }
}
