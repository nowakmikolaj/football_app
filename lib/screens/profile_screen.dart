import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';

import '../widgets/custom_appbar.dart';
import '/utils/media_query.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: CustomAppBar(
        data: 'My account',
        icon: Icons.account_circle_outlined,
        backOnTap: false,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.moon_stars),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: AppSize.s40,
            ),
            SizedBox(
              width: context.width / 3,
              height: context.width / 3,
              child: const Image(
                image: AssetImage(Assets.loginUser),
              ),
            ),
            const SizedBox(
              height: AppSize.s40,
            ),
            Text(
              user.email!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: FontSize.subTitle,
                fontWeight: FontWeights.semiBold,
              ),
            ),
            const SizedBox(height: AppSize.s100),
            Center(
              child: Button(
                text: Resources.signOut,
                onPressed: signOut,
              ),
            ),
            const SizedBox(height: AppSize.s20),
          ],
        ),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}

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
          horizontal: 32,
          vertical: 12,
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
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
