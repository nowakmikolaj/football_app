import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/models/abstract/tile_fav_element.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/tiles/tile.dart';

// ignore: must_be_immutable
class TileFav<T extends TileFavElement> extends Tile<T> {
  TileFav({
    super.key,
    required super.tileData,
    required this.isFav,
  });

  bool isFav;

  @override
  State<TileFav<T>> createState() => _TileFavState<T>();
}

class _TileFavState<T extends TileFavElement> extends State<TileFav<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.tileData.buildCard(
      context,
      [
        ...widget.tileData.buildElements(),
        favouritesAction(widget.isFav),
      ],
    );
  }

  IconButton favouritesAction(bool isFav) {
    if (isFav) {
      return IconButton(
        onPressed: () {
          widget.tileData.removeFromFavourites();
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
        widget.tileData.addToFavourites();
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