import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/my_app.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/messenger_manager.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/utils/validation.dart';
import 'package:football_app/widgets/button.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/login_text_field.dart';
import 'package:provider/provider.dart';
import 'package:football_app/utils/themes.dart';
import 'package:football_app/utils/extensions.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({
    super.key,
  });

  @override
  State<PasswordResetScreen> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordResetScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themechanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey
                : Colors.white,
            radius: AppSize.s70,
            child: Container(
              width: context.width,
              height: context.height / 10,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Assets.forgotPassword,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: AppSize.s20,
              right: AppSize.s20,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: AppSize.s30,
                  ),
                  const Text(
                    Resources.passwordResetTitle,
                    style: TextStyle(
                      fontSize: FontSize.mainTitle,
                      fontWeight: FontWeights.bold,
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s50,
                  ),
                  const Text(
                    Resources.passwordResetPrompt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSize.subTitle,
                      fontWeight: FontWeights.semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                  ),
                  LoginTextField(
                    hint: Resources.loginHint,
                    icon: Icons.email,
                    controller: emailController,
                    validate: Validation.validateEmail,
                    isPassword: false,
                  ),
                  const SizedBox(
                    height: AppSize.s30,
                  ),
                  Button(
                    text: Resources.passwordResetButton,
                    onPressed: resetPassword,
                  ),
                  const SizedBox(height: AppSize.s30),
                  IconButton(
                    icon: const Icon(CupertinoIcons.moon_stars),
                    onPressed: () => themechanger.enableDarkMode(
                        Theme.of(context).brightness == Brightness.dark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CenterIndicator(),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      MessengerManager.showMessageBarInfo(Resources.passwordResetSuccess);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      MessengerManager.showMessageBarError(e.message);
      navigatorKey.currentState!.pop();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
