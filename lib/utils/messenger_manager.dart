import 'package:flutter/material.dart';

class MessengerManager {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showMessageBarInfo(String? message) {
    _showMessageBar(message, Colors.green);
  }

  static showMessageBarWarning(String? message) {
    _showMessageBar(message, Colors.yellow);
  }

  static showMessageBarError(String? message) {
    _showMessageBar(message, Colors.red);
  }

  static _showMessageBar(String? message, Color color) {
    if (message != null) {
      final messageBar = SnackBar(
        content: Text(message),
        backgroundColor: color,
      );

      messengerKey.currentState!
        ..removeCurrentSnackBar()
        ..showSnackBar(messageBar);
    }
  }
}
