import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';


class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.s32,
          vertical: AppSize.s12,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: FontSize.subTitle,
          fontWeight: FontWeights.bold,
        ),
      ),
    );
  }
}