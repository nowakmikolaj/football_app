import 'package:football_app/models/abstract/tile_element.dart';
import 'package:football_app/models/abstract/tile_fav_element.dart';

abstract class Searchable {
  late String name;
}

abstract class SearchableTileElement extends TileElement implements Searchable {
}

abstract class SearchableFavTileElement extends TileFavElement
    implements SearchableTileElement {}
