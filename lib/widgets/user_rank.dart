import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/models/user_rank_data.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';

class UserRank extends StatelessWidget {
  final UserRankData userRankData;
  final int rank;

  const UserRank({
    super.key,
    required this.rank,
    required this.userRankData,
  });

  @override
  Widget build(BuildContext context) {
    List<String> teamData = [
      '${userRankData.placedBets}',
      '${userRankData.settledBets}',
      '${userRankData.totalPoints}',
      (userRankData.average.toStringAsFixed(2)),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s15),
        color: userRankData.userId == FirebaseAuth.instance.currentUser!.email
            ? Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]
                : Colors.grey[400]
            : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p2,
          horizontal: AppPadding.p15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SizedBox(
                width: AppSize.s30,
                height: AppSize.s20,
                child: Text(
                  '${rank.toString()}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: FontSize.bodyText),
                ),
              ),
              Text(
                userRankData.userId.split('@').first,
                style: const TextStyle(fontSize: FontSize.bodyText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
            Row(
              children: [
                ...List.generate(
                  teamData.length,
                  (index) => SizedBox(
                    width: AppSize.s46,
                    child: Text(
                      teamData[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: FontSize.bodyText),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
