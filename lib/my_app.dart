import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/screens/login_screen.dart';
import 'package:football_app/screens/main_screen.dart';
import 'package:football_app/utils/messenger_manager.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/utils/themes.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (context) => ThemeChanger(Themes.darkTheme),
      child: const MaterialAppWithTheme(),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      scaffoldMessengerKey: MessengerManager.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CenterIndicator();
          } else if (snapshot.hasError) {
            showDialog(
              context: context,
              builder: (context) => const ErrorDialog(
                title: Resources.errorTitle,
                errorMessage: Resources.authenticationErrorMessage,
              ),
            );
          }

          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
