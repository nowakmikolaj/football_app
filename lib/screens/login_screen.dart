import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:football_app/my_app.dart';
import 'package:football_app/screens/password_reset_screen.dart';
import 'package:football_app/screens/sign_up_screen.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themechanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.width,
                height: context.height / AppSize.s5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      Assets.supporter,
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
                        Resources.loginScreenTitle,
                        style: TextStyle(
                          fontSize: FontSize.mainTitle,
                          fontWeight: FontWeights.bold,
                        ),
                      ),
                      const Text(
                        Resources.loginScreenSubTitle,
                        style: TextStyle(
                          fontSize: FontSize.title,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      LoginTextField(
                        hint: Resources.loginHint,
                        icon: Icons.email,
                        controller: emailController,
                        validate: Validation.validateEmail,
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                      ),
                      LoginTextField(
                        hint: Resources.passwordHint,
                        icon: Icons.password,
                        controller: passwordController,
                        validate: Validation.validatePassword,
                        isPassword: true,
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PasswordResetScreen(),
                              ),
                            ),
                            child: const Text(
                              Resources.loginScreenForgotPassword,
                              style: TextStyle(
                                fontSize: FontSize.subTitle,
                                fontWeight: FontWeights.light,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      Button(
                        text: Resources.loginScreenSignInButton,
                        onPressed: signIn,
                      ),
                      SizedBox(
                        height: context.height / AppSize.s15,
                      ),
                      RichText(
                        text: TextSpan(
                          text: Resources.loginScreenNoAccount,
                          style: TextStyle(
                            fontSize: FontSize.details,
                            color: Colors.grey[500],
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const SignUpScreen(),
                                      ),
                                    ),
                              text: Resources.loginScreenCreateAccount,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: FontSize.details,
                                fontWeight: FontWeights.bold,
                              ),
                            ),
                          ],
                        ),
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
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CenterIndicator(),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      navigatorKey.currentState!.pop();
    } on FirebaseAuthException catch (e) {
      MessengerManager.showMessageBarError(e.message);
      navigatorKey.currentState!.pop();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
