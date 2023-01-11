import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';

abstract class TileElement {
  List<Widget> buildElements();
  Widget nextScreen();

  GestureDetector buildCard(BuildContext context, List<Widget> elements) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => nextScreen(),
        ),
      ),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(5.0),
          child: Padding(
            padding:
                const EdgeInsets.only(left: AppSize.s25, right: AppSize.s15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: elements,
            ),
          ),
        ),
      ),
    );
  }
}
