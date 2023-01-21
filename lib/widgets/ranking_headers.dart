import 'package:flutter/material.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/resources.dart';

class RankingHeaders extends StatelessWidget {
  const RankingHeaders({
    super.key,
    this.displayGroupName = '',
  });

  final String? displayGroupName;

  static const List<String> _headers = [
    "Placed",
    "Settled",
    "Total",
    "Average",
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
                    style: const TextStyle(fontSize: FontSize.subTitle),
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
                children: const [
                  SizedBox(
                    width: AppSize.s30,
                    child: Text(
                      '#',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppSize.s16),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      Resources.rankingHeadersUser,
                      style: TextStyle(fontSize: AppSize.s16),
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
                      width: AppSize.s46,
                      child: Text(
                        _headers[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: AppSize.s16),
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
