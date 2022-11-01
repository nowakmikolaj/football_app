import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/country.dart';
import '../providers/countries_provider.dart';
import '../utils/utils.dart';
import '../widgets/country_tile.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  List<Country> _countries = [];

  Future<void> _fetchCountries() async {
    final countries = await CountriesProvider.fetchCountries();
    setState(() => _countries = countries);
  }

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return CountriesProvider(
      countries: _countries,
      child: Scaffold(
        appBar: Utils.createAppBar(
          'Countries',
          Icons.map_outlined,
        ),
        body: CountryList(countries: _countries),
      ),
    );
  }
}

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
