import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget{
  const AppBarComponent({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context){
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Colors.green.shade800],
          ),
        ),
      ),
      title: Image.asset(
        "assets/images/Logo_SMK.png",
        width: 45,
        height: 45,
      ),
      centerTitle: true,
      toolbarHeight: 60,
    );
  }
}