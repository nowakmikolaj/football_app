import 'package:flutter/material.dart';
import 'package:football_app/datasources/country_data_source.dart';
import '../models/country.dart';
import '../widgets/center_indicator.dart';
import '../widgets/country_list.dart';
import '../widgets/custom_appbar.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({
    super.key,
  });

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  late Future<List<Country>> _countries;

  Future<void> _fetchCountries() async {
    _countries = CountryDataSource.instance.getCountries();
    // setState(() => _countries = countries);
  }

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        data: 'Countries',
        icon: Icons.map_outlined,
        backOnTap: false,
      ),
      body: FutureBuilder(
          future: _countries,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CountryList(countries: snapshot.data ?? []);
            } else {
              return const CenterIndicator();
            }
          }),
    );
  }
}
