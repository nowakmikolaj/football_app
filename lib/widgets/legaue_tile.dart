import 'package:flutter/material.dart';

import '../models/league.dart';

class LeagueTile extends StatelessWidget {
  const LeagueTile({
    super.key,
    this.league,
  });

  final League? league;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Premier League',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
