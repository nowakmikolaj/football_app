import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/screens/home_screen.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/extensions.dart';
import 'package:football_app/utils/messenger_manager.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canSendEmail = true;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) sendVerificationEmail();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width,
                  height: context.height / AppSize.s10,
                  child: const Expanded(
                      child: Icon(
                    Icons.email_outlined,
                    size: AppSize.s100,
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: AppSize.s20,
                    right: AppSize.s20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      const Text(
                        Resources.verifyEmailTitle,
                        style: TextStyle(
                          fontSize: FontSize.mainTitle,
                          fontWeight: FontWeights.bold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      const Text(
                        Resources.verifyEmailMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FontSize.title,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      Button(
                        text: Resources.sendVerificationEmailButton,
                        onPressed: () => sendVerificationEmail(),
                      ),
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      Button(
                        text: Resources.verifiedEmailButton,
                        onPressed: () => FirebaseAuth.instance.signOut(),
                      ),
                      SizedBox(
                        height: context.height / AppSize.s15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Future sendVerificationEmail() async {
    if (!canSendEmail) {
      MessengerManager.showMessageBarWarning(Resources.emailCannotBeSent);
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canSendEmail = false);
      await Future.delayed(const Duration(minutes: 1));
      setState(() => canSendEmail = true);

      MessengerManager.showMessageBarInfo(Resources.emailSent);
    } catch (e) {
      MessengerManager.showMessageBarError(e.toString());
    }
  }
}
