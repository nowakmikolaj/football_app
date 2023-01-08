import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
    required this.assetImage,
    required this.message,
  }) : super(key: key);

  final String assetImage;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(assetImage),
          width: AppSize.s200,
          height: AppSize.s200,
        ),
        const SizedBox(
          height: AppSize.s20,
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
