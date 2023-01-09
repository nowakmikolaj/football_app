import 'package:football_app/models/abstract/tile_element.dart';

abstract class TileFavElement extends TileElement {
  Future addToFavourites();
  Future removeFromFavourites();
}