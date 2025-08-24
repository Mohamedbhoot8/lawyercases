import 'package:flutter/material.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  const Customappbar({
    super.key,
    required this.title,
    this.backgcolor,
    this.textcolor,
  });
  final String title;
  final Color? backgcolor, textcolor;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: textcolor),
        ),
        backgroundColor: backgcolor);
  }
}
