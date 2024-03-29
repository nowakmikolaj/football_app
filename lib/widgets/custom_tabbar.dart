import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';

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
        style: const TextStyle(
          color: Colors.white,
          fontSize: FontSize.bodyText,
        ),
      ),
    );
  }
}
