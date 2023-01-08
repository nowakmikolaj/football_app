import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/extensions.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/button.dart';
import 'package:football_app/widgets/custom_appbar.dart';

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
      appBar: const CustomAppBar(
        data: 'My account',
        icon: Icons.account_circle_outlined,
        backOnTap: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: AppSize.s40,
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]
                  : Colors.white,
              radius: AppSize.s70,
              child: SizedBox(
                width: context.width / 3,
                height: context.width / 3,
                child: const Image(
                  image: AssetImage(Assets.loginUser),
                ),
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
