import 'package:flutter/material.dart';

import '../models/league.dart';

class LeagueTile extends StatelessWidget {
  const LeagueTile({
    super.key,
    required this.league,
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
          children: [
            Text(
              league!.name,
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Icon(
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
