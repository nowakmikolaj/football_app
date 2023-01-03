import 'package:flutter/material.dart';
import 'package:football_app/widgets/custom_tabbar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.data,
    required this.icon,
    required this.backOnTap,
  }) : super(key: key);

  final IconData icon;
  final String data;
  final bool backOnTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
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
  Size get preferredSize => const Size.fromHeight(60.0);
}
