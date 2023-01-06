import 'package:flutter/material.dart';
import '../utils/app_padding.dart';
import '../utils/app_size.dart';

class StandingsHeaders extends StatelessWidget {
  const StandingsHeaders({
    super.key,
    this.displayGroupName = '',
  });

  final String? displayGroupName;

  static const List<String> _headers = [
    "P",
    "G",
    "Pts",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (displayGroupName != null && displayGroupName!.isNotEmpty)
          Container(
            color: Colors.grey.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Text(
                    displayGroupName!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        Container(
          color: Colors.grey.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p5,
            horizontal: AppPadding.p15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(
                    width: AppSize.s30,
                    child: Text(
                      '#',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    child: Text(
                      'Team',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(
                    _headers.length,
                    (index) => SizedBox(
                      width: AppSize.s40,
                      child: Text(
                        _headers[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
