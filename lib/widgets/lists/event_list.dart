import 'package:flutter/material.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/fixture_event.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/event_data.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.events,
    required this.fixture,
  });
  final List<FixtureEvent> events;
  final Fixture fixture;

  @override
  Widget build(BuildContext context) {
    final firstHalfEvents =
        events.where((element) => element.isFirstHalf()).toList();
    final secondHalfEvents =
        events.where((element) => element.isSecondHalf()).toList();
    final extraTimeEvents =
        events.where((element) => element.isExtraTime()).toList();
    final penalties =
        events.where((element) => element.isPenaltyShootout()).toList();

    final arrays = [
      firstHalfEvents,
      secondHalfEvents,
      extraTimeEvents,
      penalties,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          arrays.length,
          (index) => buildHalf(index + 1, arrays[index]),
        ),
      ],
    );
  }

  Widget buildHalf(int half, List<FixtureEvent> events) {
    String halfText = '';
    switch (half) {
      case 1:
        halfText = Resources.firstHalf;
        break;
      case 2:
        halfText = Resources.secondHalf;
        break;
      case 3:
        halfText = Resources.extraTime;
        break;
      case 4:
        halfText = Resources.penaltyShootout;
        break;
    }

    if (events.isEmpty) return Container();

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                halfText,
                style: const TextStyle(fontSize: FontSize.subTitle),
              ),
            ],
          ),
        ),
        ...List.generate(
          events.length,
          (index) {
            final event = events[index];
            return Padding(
              padding: const EdgeInsets.only(top: AppSize.s8),
              child: Column(
                children: [
                  EventDataWidget(
                    event: event,
                    homeTeamId: fixture.homeTeam.teamId,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: AppSize.s20,
        ),
      ],
    );
  }
}