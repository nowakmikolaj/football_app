import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:football_app/datasources/firestore_data_source.dart';
import 'package:football_app/my_app.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/extensions.dart';
import 'package:football_app/utils/messenger_manager.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/utils/themes.dart';
import 'package:football_app/utils/validation.dart';
import 'package:football_app/widgets/button.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/login_text_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

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
                height: context.height / AppSize.s10,
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
                        Resources.signUpScreenTitle,
                        style: TextStyle(
                          fontSize: FontSize.mainTitle,
                          fontWeight: FontWeights.bold,
                        ),
                      ),
                      const Text(
                        Resources.signUpScreenSubTitle,
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
                        isPassword: true,
                        validate: Validation.validatePassword,
                      ),
                      const SizedBox(
                        height: AppSize.s20,
                      ),
                      LoginTextField(
                        hint: Resources.repeatPasswordHint,
                        icon: Icons.password,
                        controller: passwordController2,
                        isPassword: true,
                        validate: (password) =>
                            password != passwordController.text
                                ? Resources.passwordRepeatValidationError
                                : null,
                      ),
                      const SizedBox(
                        height: AppSize.s50,
                      ),
                      Button(
                        text: Resources.signUpScreenButton,
                        onPressed: signUp,
                      ),
                      SizedBox(
                        height: context.height / AppSize.s15,
                      ),
                      RichText(
                        text: TextSpan(
                          text: Resources.signUpScreenHaveAccount,
                          style: TextStyle(
                            fontSize: FontSize.details,
                            color: Colors.grey[500],
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).pop(),
                              text: Resources.signUpScreenSignIn,
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CenterIndicator(),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      FirestoreDataSource.instance.addUser(emailController.text);

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      MessengerManager.showMessageBarError(e.message);
      navigatorKey.currentState!.pop();
    } catch (e) {
      MessengerManager.showMessageBarError(e.toString());
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
