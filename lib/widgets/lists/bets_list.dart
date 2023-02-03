import 'package:flutter/material.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/screens/fixture_details_screen.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/fixture_header.dart';
import 'package:football_app/widgets/lists/empty_list.dart';

class BetsList extends StatelessWidget {
  const BetsList({
    super.key,
    required this.bets,
    required this.headerText,
    this.displaySummary = false,
  });

  final List<Bet> bets;
  final bool displaySummary;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    return bets.isNotEmpty
        ? ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              displaySummary
                  ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey[400],
                      ),
                      padding: const EdgeInsets.only(
                        top: AppPadding.p10,
                        bottom: AppPadding.p10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bets placed: ${bets.length}",
                            style: const TextStyle(fontSize: FontSize.subTitle),
                          ),
                          Text(
                            "Total points: ${getPoints(bets)}",
                            style: const TextStyle(fontSize: FontSize.subTitle),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      headerText,
                      style: const TextStyle(fontSize: FontSize.subTitle),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                bets.length,
                (index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FixtureDetailsScreen(
                        fixture: bets[index].fixture!,
                      ),
                    ),
                  ),
                  child: Card(
                    elevation: AppSize.s3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSize.s25,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(
                        AppSize.s5,
                      ),
                      child: FixtureHeader(
                        fixture: bets[index].fixture!,
                        bet: [bets[index]],
                        isHeader: false,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        : const EmptyList(
            assetImage: Assets.noBets,
            message: Resources.betsNotFound,
          );
  }

  int getPoints(List<Bet> bets) => bets
      .map((e) => e.points ?? 0)
      .reduce((value, element) => value + element);
}
