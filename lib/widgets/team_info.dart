import 'package:flutter/material.dart';
import 'package:football_app/models/team.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:transparent_image/transparent_image.dart';

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
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            fit: BoxFit.cover,
            image: team.logo,
            width: AppSize.s35,
            height: AppSize.s35,
            fadeInDuration: const Duration(milliseconds: 400),
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
