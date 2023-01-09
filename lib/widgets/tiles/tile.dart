import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/utils/app_size.dart';

class Tile<T extends TileElement> extends StatefulWidget {
  const Tile({
    super.key,
    required this.tileData,
  });

  final T tileData;

  @override
  State<Tile<T>> createState() => _TileState<T>();
}

class _TileState<T extends TileElement> extends State<Tile<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.tileData.buildCard(
      context,
      [...widget.tileData.buildElements()],
    );
  }
}
