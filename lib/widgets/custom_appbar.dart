import 'package:flutter/material.dart';
import 'package:football_app/utils/actions.dart';
import 'package:football_app/utils/app_size.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.data,
    required this.icon,
    required this.backOnTap,
    this.actions,
  }) : super(key: key);

  final IconData icon;
  final String data;
  final bool backOnTap;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      actions: [
          getThemeModeAction(context),
        ],
      centerTitle: true,
      leading: GestureDetector(
        onTap: backOnTap ? () => Navigator.pop(context) : () => {},
        child: Icon(icon),
      ),
      title: Text(
        data,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
    );
  }

  

  @override
  Size get preferredSize => const Size.fromHeight(AppSize.s50);
}
