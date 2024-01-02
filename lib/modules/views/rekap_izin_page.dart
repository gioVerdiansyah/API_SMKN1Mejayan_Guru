import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';

class RekapIzinPage extends StatefulWidget{
  const RekapIzinPage({super.key});
  static const String routeName = '/rekap/izin';

  @override
  State<RekapIzinPage> createState() => _RekapJurnalView();
}

class _RekapJurnalView extends State<RekapIzinPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Card(
            child: Text("Hello"),
          ),
        ),
      ),
    );
  }
}