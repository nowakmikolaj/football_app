import 'package:flutter/material.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/resources.dart';

class BetInfo extends StatelessWidget {
  const BetInfo({
    Key? key,
    required this.bet,
    required this.fixture,
    required this.isHeader,
  }) : super(key: key);

  final Bet bet;
  final Fixture fixture;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSize.s20),
        Container(
          width: AppSize.s150,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p15,
            vertical: AppPadding.p2,
          ),
          decoration: BoxDecoration(
            color: isHeader
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey
                : Colors.black38,
            borderRadius: BorderRadius.circular(AppSize.s20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${Resources.placedBet} ${bet.goals!.home} : ${bet.goals!.away}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: FontSize.subTitle),
              ),
              fixture.isFinished()
                  ? Text(
                      "${Resources.earnedPoints} ${bet.points ?? '?'}",
                      style: const TextStyle(
                        fontSize: FontSize.subTitle,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
