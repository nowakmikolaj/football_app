import 'package:flutter/material.dart';
import 'package:football_app/models/team_rank_data.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:transparent_image/transparent_image.dart';

class TeamRank extends StatelessWidget {
  final TeamRankData teamRankData;
  const TeamRank({
    super.key,
    required this.teamRankData,
  });

  @override
  Widget build(BuildContext context) {
    List<String> teamData = [
      '${teamRankData.played}',
      '${teamRankData.goalsFor}:${teamRankData.goalsAgainst}',
      '${teamRankData.points}',
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
                '${teamRankData.rank.toString()}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: FontSize.bodyText),
              ),
            ),
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: teamRankData.team.logo,
              width: AppSize.s20,
              height: AppSize.s20,
              fadeInDuration: const Duration(milliseconds: 400),
            ),
            const SizedBox(
              width: AppSize.s10,
            ),
            Text(
              teamRankData.team.name,
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
                  width: AppSize.s40,
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
    );
  }
}
