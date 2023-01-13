import 'package:flutter/material.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/tiles/tile.dart';

class CountryList extends StatelessWidget {
  const CountryList({
    Key? key,
    required List<Country> countries,
  })  : _countries = countries,
        super(key: key);

  final List<Country> _countries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        ...List.generate(
          _countries.length,
          (index) {
            final country = _countries[index];
            return Padding(
              padding: const EdgeInsets.only(top: AppSize.s8),
              child: Tile<Country>(
                tileData: country,
                key: ValueKey(country.name),
              ),
            );
          },
        ),
      ],
    );
  }
}
