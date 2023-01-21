import 'package:flutter/material.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/user_rank_data.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/lists/empty_list.dart';
import 'package:football_app/widgets/ranking_headers.dart';
import "package:collection/collection.dart";
import 'package:football_app/widgets/user_rank.dart';

class RankingList extends StatelessWidget {
  const RankingList({
    super.key,
    required this.bets,
  });

  final List<Bet> bets;

  @override
  Widget build(BuildContext context) {
    final grouped = groupBy(bets, (bet) => bet.userId);

    List<UserRankData> ranking = [];
    for (final key in grouped.keys) {
      ranking.add(UserRankData(userId: key!, bets: grouped[key]!));
    }

    ranking.sort(((a, b) => a.compareTo(b)));

    return bets.isNotEmpty
        ? ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const RankingHeaders(),
              ...List.generate(
                ranking.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSize.s8),
                    child: UserRank(
                      rank: index + 1,
                      userRankData: ranking[index],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: AppSize.s20,
              ),
            ],
          )
        : const EmptyList(
            assetImage: Assets.standingsNotFound,
            message: Resources.standingsNotFound,
          );
  }
}
