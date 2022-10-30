import 'package:flutter/material.dart';
import 'package:football_app/screens/fixtures_screen.dart';
import 'package:football_app/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> widgets = <Widget>[
    const FixtureScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Fixtures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amberAccent,
        onTap: onItemSelected,
      ),
    );
  }
}
