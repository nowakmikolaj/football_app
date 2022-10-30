import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text(
            'My profile',
          ),
        ),
      ),
    );
  }
}
