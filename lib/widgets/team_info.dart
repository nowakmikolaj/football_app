import 'package:flutter/material.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/utils/app_size.dart';

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