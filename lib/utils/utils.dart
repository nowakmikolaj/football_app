import 'package:flutter/material.dart';

class Utils {
  static AppBar createAppBar(
    String data,
    IconData icon,
  ) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: Icon(icon),
      title: Text(
        data,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
    );
  }
}
