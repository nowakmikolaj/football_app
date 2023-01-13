import 'package:flutter/material.dart';
import 'package:football_app/screens/countries_screen.dart';
import 'package:football_app/screens/favourites_screen.dart';
import 'package:football_app/screens/profile_screen.dart';
import 'package:football_app/utils/resources.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> widgets = <Widget>[
    const CountriesScreen(),
    const FavouritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: Resources.navBarHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline_rounded),
            label: Resources.navBarFavourites,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: Resources.navBarProfile,
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemSelected,
      ),
    );
  }
}
