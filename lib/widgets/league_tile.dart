import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';

import '../models/league.dart';
import '../screens/league_details_screen.dart';

class LeagueTile extends StatefulWidget {
  const LeagueTile({
    super.key,
    required this.league,
  });

  final League league;

  @override
  State<LeagueTile> createState() => _LeagueTileState();
}

class _LeagueTileState extends State<LeagueTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s50,
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black26
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LeagueDetailsScreen(
              league: widget.league,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image(
                width: 32,
                height: 32,
                image: NetworkImage(widget.league.logo),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.league.country!.name,
                        style: const TextStyle(
                          overflow: TextOverflow.fade,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        widget.league.name,
                        softWrap: false,
                        style: const TextStyle(
                          overflow: TextOverflow.fade,
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
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
