import 'package:flutter/material.dart';
import 'package:football_app/screens/countries_screen.dart';
import 'package:football_app/screens/favourites_screen.dart';
import 'package:football_app/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 1;

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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline_rounded),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemSelected,
      ),
    );
  }
}
