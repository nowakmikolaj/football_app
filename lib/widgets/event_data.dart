// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:football_app/models/event_data.dart';
import 'package:football_app/models/fixture_event.dart';
import 'package:football_app/utils/app_size.dart';

class EventDataWidget extends StatelessWidget {
  EventDataWidget({
    Key? key,
    required this.event,
    required int homeTeamId,
  }) : super(key: key) {
    _eventData = event.mapToEventData();
    isHomeTeam = event.teamId == homeTeamId;
  }

  late EventData _eventData;
  late bool isHomeTeam;
  final FixtureEvent event;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: isHomeTeam
              ? Text(
                  _eventData.getText(),
                  textAlign: TextAlign.right,
                )
              : Container(),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: AppSize.s20,
            child: isHomeTeam
                ? Image(
                    image: AssetImage(
                      _eventData.getIconAsset(),
                    ),
                  )
                : Container(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(AppSize.s15),
            ),
            child: Text(
              event.extra == null
                  ? "${event.elapsed.toString()}'"
                  : "${event.elapsed.toString()}'+${event.extra}'",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: AppSize.s20,
            child: !isHomeTeam
                ? Image(
                    image: AssetImage(
                      _eventData.getIconAsset(),
                    ),
                  )
                : Container(),
          ),
        ),
        Expanded(
          flex: 4,
          child: !isHomeTeam
              ? Text(
                  _eventData.getText(),
                  textAlign: TextAlign.left,
                )
              : Container(),
        ),
      ],
    );
  }
}