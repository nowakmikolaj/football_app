import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football_app/screens/leagues_screen.dart';
import 'package:football_app/utils/app_size.dart';

import '../models/country.dart';

class CountryTile extends StatefulWidget {
  const CountryTile({
    super.key,
    required this.country,
  });

  final Country country;

  @override
  State<CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<CountryTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LeaguesScreen(
              country: widget.country,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: widget.country.flag.isNotEmpty
                      ? SvgPicture.network(widget.country.flag)
                      : Container(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.country.name.toUpperCase(),
                          softWrap: false,
                          style: const TextStyle(
                            overflow: TextOverflow.fade,
                            fontWeight: FontWeights.semiBold,
                            fontSize: FontSize.subTitle,
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
      ),
    );
  }
}
