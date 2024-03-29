import 'package:flutter/material.dart';

class CenterIndicator extends StatelessWidget {
  const CenterIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}