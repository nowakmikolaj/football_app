import 'package:flutter/material.dart';
import 'package:football_app/models/team_rank.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';

class TeamRankTile extends StatelessWidget {
  final TeamRank teamRank;
  const TeamRankTile({
    super.key,
    required this.teamRank,
  });

  @override
  Widget build(BuildContext context) {
    List<String> teamData = [
      '${teamRank.played}',
      '${teamRank.goalsFor}:${teamRank.goalsAgainst}',
      '${teamRank.points}',
    ];

    return Padding(
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
                '${teamRank.rank.toString()}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Image(
              width: AppSize.s20,
              height: AppSize.s20,
              image: NetworkImage(teamRank.team.logo),
            ),
            const SizedBox(
              width: AppSize.s10,
            ),
            Text(
              teamRank.team.name,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
          Row(
            children: [
              ...List.generate(
                teamData.length,
                (index) => SizedBox(
                  width: AppSize.s40,
                  child: Text(
                    teamData[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
