import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppTopBar({super.key, this.title = 'Magic: The Gathering Cartas'});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
        style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 25),),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
