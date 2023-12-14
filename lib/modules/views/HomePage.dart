import 'package:flutter/material.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomeView();
}

class _HomeView extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return const Scaffold(
      appBar: AppBarComponent(),
      drawer: SideBarComponent(),
      body: Text("Hello World"),
    );
  }
}