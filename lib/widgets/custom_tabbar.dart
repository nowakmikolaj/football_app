import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
