import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/screens/profile_screen.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:provider/provider.dart';
import '../utils/themes.dart';
import '../utils/extensions.dart';

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
    final themechanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
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
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                LoginTextField(
                  hint: Resources.passwordHint,
                  icon: Icons.password,
                  controller: passwordController,
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
                    const Text(
                      Resources.loginScreenForgotPassword,
                      style: TextStyle(
                        fontSize: FontSize.subTitle,
                        fontWeight: FontWeights.light,
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
                const SizedBox(height: AppSize.s30),
                IconButton(
                  icon: const Icon(CupertinoIcons.moon_stars),
                  onPressed: () => themechanger.enableDarkMode(
                      Theme.of(context).brightness == Brightness.dark),
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

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s30),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(1, 1),
            color: Colors.grey.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(
              widget.icon,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : const Icon(Icons.abc),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
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
