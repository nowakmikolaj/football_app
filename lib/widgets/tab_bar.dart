import 'package:flutter/material.dart';

class BarTab extends StatelessWidget {
  const BarTab({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(date),
    );
  }
}
