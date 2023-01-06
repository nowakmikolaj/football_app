import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/screens/profile_screen.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import '/utils/media_query.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // backgroundColor: Colors.grey.withOpacity(0.6),
      body: Column(
        children: [
          SizedBox(
            height: context.height / 10,
          ),
          Container(
            width: context.width,
            height: context.height / 10,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.loginUser,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: AppSize.s20,
              right: AppSize.s20,
            ),
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
                Text(
                  Resources.loginScreenSubTitle,
                  style: TextStyle(
                    fontSize: FontSize.title,
                    fontWeight: FontWeights.semiBold,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  height: AppSize.s50,
                ),
                LoginTextField(
                  hint: Resources.loginHint,
                  icon: Icons.email,
                  controller: emailController,
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                LoginTextField(
                  hint: Resources.passwordHint,
                  icon: Icons.password,
                  controller: passwordController,
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      Resources.loginScreenForgotPassword,
                      style: TextStyle(
                        fontSize: FontSize.subTitle,
                        fontWeight: FontWeights.light,
                        color: Colors.grey[500],
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
                  height: context.height / 15,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) return;

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    Key? key,
    required this.hint,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0),
        borderRadius: BorderRadius.circular(AppSize.s30),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(1, 1),
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: Colors.grey,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(AppSize.s30),
            )),
      ),
    );
  }
}
