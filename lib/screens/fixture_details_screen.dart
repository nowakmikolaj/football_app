import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/custom_appbar.dart';

class FixtureDetailsScreen extends StatefulWidget {
  const FixtureDetailsScreen({super.key, required this.fixture});

  final Fixture fixture;

  @override
  State<FixtureDetailsScreen> createState() => _FixtureDetailsScreenState();
}

class _FixtureDetailsScreenState extends State<FixtureDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        data:
            "${widget.fixture.homeTeam.name} vs ${widget.fixture.awayTeam.name}",
        icon: Icons.arrow_back_ios,
        backOnTap: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          FixtureHeader(fixture: widget.fixture),
        ],
      ),
    );
  }
}

// TODO: czy potrzebne?
class FixtureDetailsTabBar extends StatelessWidget {
  const FixtureDetailsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TabBar(tabs: []),
        ),
      ],
    );
  }
}

class TeamFixtureTile extends StatelessWidget {
  const TeamFixtureTile({
    Key? key,
    required this.team,
  }) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: AppSize.s25,
            child: Image(
              fit: BoxFit.cover,
              width: AppSize.s40,
              height: AppSize.s40,
              image: NetworkImage(team.logo),
            ),
          ),
          const SizedBox(
            height: AppSize.s10,
          ),
          FittedBox(
            child: Text(
              team.name.split(" ").length >= 3
                  ? team.name.split(" ").sublist(0, 2).join(" ")
                  : team.name,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class FixtureHeader extends StatelessWidget {
  const FixtureHeader({super.key, required this.fixture});

  final Fixture fixture;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      padding: const EdgeInsets.only(
        top: AppPadding.p20,
        bottom: AppPadding.p20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                fit: BoxFit.cover,
                width: AppSize.s20,
                height: AppSize.s20,
                image: NetworkImage(fixture.league.logo),
              ),
              const SizedBox(
                width: AppSize.s5,
              ),
              Text(
                fixture.league.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: AppSize.s10,
          ),
          Row(
            children: [
              ...fixture.buildElements(),
            ],
          ),
          fixture.isUpcoming()
              ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Place a bet"),
                    ),
                  ],
                )
              : Container(),
          // TODO: dodac gole i eventy
        ],
      ),
    );
  }
}

              // TeamFixtureTile(team: fixture.homeTeam),
              // Expanded(
              //   child: fixture.isUpcoming()
              //       ? Column(
              //           children: [
              //             Text(
              //               fixture.Datetime,
              //               textAlign: TextAlign.center,
              //               style: const TextStyle(fontSize: FontSize.details),
              //             ),
              //             const SizedBox(
              //               height: AppSize.s5,
              //             ),
              //             ElevatedButton(
              //               onPressed: () {},
              //               child: const Text("Place a bet"),
              //             ),
              //           ],
              //         )
              //       :
              //       //TODO: extract bo to to samo co w FixtureTile
              //       Column(
              //           children: [
              //             !fixture.isLive()
              //                 ? Column(
              //                     children: [
              //                       Text(
              //                         fixture.Date,
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     ],
              //                   )
              //                 : Container(),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Text(
              //                   fixture.goals.home != null
              //                       ? fixture.goals.home.toString()
              //                       : '',
              //                   style:
              //                       const TextStyle(fontSize: FontSize.title),
              //                 ),
              //                 !fixture.isUpcoming()
              //                     ? const Text(
              //                         ":",
              //                         style:
              //                             TextStyle(fontSize: FontSize.title),
              //                       )
              //                     : Container(),
              //                 Text(
              //                   fixture.goals.away != null
              //                       ? fixture.goals.away.toString()
              //                       : '',
              //                   style:
              //                       const TextStyle(fontSize: FontSize.title),
              //                 )
              //               ],
              //             ),
              //             const SizedBox(height: AppSize.s2),
              //             Container(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: AppPadding.p15,
              //                 vertical: AppPadding.p2,
              //               ),
              //               decoration: BoxDecoration(
              //                 color: fixture.isFinished()
              //                     ? Colors.red
              //                     : Colors.blue,
              //                 borderRadius: BorderRadius.circular(AppSize.s20),
              //               ),
              //               child: Text(
              //                 fixture.status,
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .bodySmall
              //                     ?.copyWith(
              //                         color: Colors.white,
              //                         fontSize: FontSize.paragraph),
              //                 textAlign: TextAlign.center,
              //               ),
              //             )
              //           ],
              //         ),
              // ),
              // TeamFixtureTile(team: fixture.awayTeam),