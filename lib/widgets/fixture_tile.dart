import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/fixture_status.dart';

class FixtureTile extends StatefulWidget {
  const FixtureTile({
    super.key,
    required this.fixture,
  });

  final Fixture fixture;

  @override
  State<FixtureTile> createState() => _FixtureTileState();
}

class _FixtureTileState extends State<FixtureTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TeamInfo(
              team: widget.fixture.homeTeam,
            ),
            (getStatus(widget.fixture.status) == FixtureStatus.NS)
                ? Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.fixture.Datetime,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        !isLive(widget.fixture)
                            ? Column(
                                children: [
                                  Text(
                                    widget.fixture.Date,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.fixture.goals.home != null
                                  ? widget.fixture.goals.home.toString()
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              ":",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              widget.fixture.goals.away != null
                                  ? widget.fixture.goals.away.toString()
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(height: AppSize.s2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p15,
                            vertical: AppPadding.p2,
                          ),
                          decoration: BoxDecoration(
                            color: getStatus(widget.fixture.status) !=
                                    FixtureStatus.FT
                                ? Colors.red
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(AppSize.s20),
                          ),
                          child: Text(
                            widget.fixture.status,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontSize: FontSize.paragraph),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
            TeamInfo(
              team: widget.fixture.awayTeam,
            ),
          ],
        ),
      ),
    );
  }
}

class TeamInfo extends StatelessWidget {
  const TeamInfo({
    Key? key,
    required this.team,
  }) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image(
            fit: BoxFit.cover,
            height: AppSize.s35,
            width: AppSize.s35,
            image: NetworkImage(team.logo),
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            team.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeights.medium,
                  fontSize: FontSize.details,
                ),
          ),
        ],
      ),
    );
  }
}
