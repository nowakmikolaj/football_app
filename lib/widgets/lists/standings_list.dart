import 'package:flutter/material.dart';
import 'package:football_app/models/standings.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/lists/empty_list.dart';
import 'package:football_app/widgets/standings_headers.dart';
import 'package:football_app/widgets/team_rank.dart';

class StandingsList extends StatelessWidget {
  const StandingsList({
    super.key,
    required this.standings,
  });

  final Standings standings;

  @override
  Widget build(BuildContext context) {
    return standings.standings.isNotEmpty
        ? ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ...List.generate(
                standings.standings.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (standings.standings.length > 1)
                      StandingsHeaders(
                        displayGroupName: standings.standings[index][0].group,
                      )
                    else
                      const StandingsHeaders(),
                    ...List.generate(
                      standings.standings[index].length,
                      (teamIndex) {
                        final teamRank = standings.standings[index][teamIndex];
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSize.s8),
                          child: TeamRank(
                            teamRankData: teamRank,
                            key: ValueKey(teamRank.team.teamId),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                  ],
                ),
              )
            ],
          )
        : const EmptyList(
            assetImage: Assets.standingsNotFound,
            message: Resources.standingsNotFound,
          );
  }
}
