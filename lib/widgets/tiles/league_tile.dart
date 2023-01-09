import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/league.dart';
import 'package:football_app/screens/league_details_screen.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/messenger_manager.dart';

class LeagueTile extends StatefulWidget {
  LeagueTile({
    super.key,
    required this.league,
    required this.isFav,
  });

  bool isFav;
  final League league;

  @override
  State<LeagueTile> createState() => _LeagueTileState();
}

class _LeagueTileState extends State<LeagueTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          //TODO: odkomentować
          Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LeagueDetailsScreen(
            league: widget.league,
          ),
        ),
      ),
      child: Container(
        height: AppSize.s50,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black26
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
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
              favouritesAction(widget.isFav),
            ],
          ),
        ),
      ),
    );
  }

  IconButton favouritesAction(bool isFav) {
    if (isFav) {
      return IconButton(
        onPressed: () {
          FirestoreService.removeFromFavourites(widget.league);
          setState(() {
            widget.isFav = !widget.isFav;
          });
        },
        icon: const Icon(CupertinoIcons.star_fill),
        splashRadius: AppSize.s15,
        iconSize: AppSize.s20,
      );
    }

    return IconButton(
      onPressed: () {
        FirestoreService.addToFavourites(widget.league);
        setState(() {
          widget.isFav = !widget.isFav;
        });
      },
      icon: const Icon(CupertinoIcons.star),
      splashRadius: AppSize.s15,
      iconSize: AppSize.s20,
    );
  }
}
