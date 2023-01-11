import 'package:flutter/material.dart';
import 'package:football_app/utils/app_size.dart';

// ignore: must_be_immutable
class LoginTextField extends StatefulWidget {
  LoginTextField({
    Key? key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.validate,
    this.isPassword = false,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  String? Function(String?) validate;

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
      child: TextFormField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validate,
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
