import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/models/country.dart';
import 'package:football_app/utils/actions.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_appbar.dart';
import 'package:football_app/widgets/lists/country_list.dart';

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
    _countries = FirestoreDataSource.instance.getCountries();
  }

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        data: Resources.countriesScreenTitle,
        icon: CupertinoIcons.flag,
        backOnTap: false,
        actions: [
          getActionSearchByName(context),
        ],
      ),
      body: FutureBuilder(
          future: _countries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final data = snapshot.data ?? [];
              data.sort(((a, b) => a.compareTo(b)));
              return CountryList(countries: data);
            } else {
              return const CenterIndicator();
            }
          }),
    );
  }
}
