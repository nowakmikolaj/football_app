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
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        // border: const Border(bottom: BorderSide(color: Colors.grey)),
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: league!.logo,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      league!.country!.name,
                      style: const TextStyle(
                        overflow: TextOverflow.fade,
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      league!.name,
                      softWrap: false,
                      style: const TextStyle(
                        overflow: TextOverflow.fade,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
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
