import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/utils/extensions.dart';

IconButton getThemeModeAction(BuildContext context) {
  return IconButton(
    icon: const Icon(CupertinoIcons.moon_stars),
    onPressed: () => context.themeChanger
        .enableDarkMode(Theme.of(context).brightness == Brightness.dark),
  );
}

IconButton getActionSignOut() {
  return const IconButton(
    icon: Icon(Icons.exit_to_app_rounded),
    onPressed: signOut,
  );
}

void signOut() {
  FirebaseAuth.instance.signOut();
}
