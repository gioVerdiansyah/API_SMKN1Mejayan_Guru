import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/routes/app_route.dart';

import 'component/utility.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static const String routeName = '/home';

  final box = GetStorage();

  @override
  State<HomePage> createState() => _HomeView();
}

class _HomeView extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final guru = widget.box.read('dataLogin')['guru'] ?? "";
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            children: [
              FadeTransition(
                opacity: _opacityAnimation,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Selamat datang ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${truncateAndCapitalizeLastWord(guru['nama'])}" " ${guru['gelar']}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Text(
                      "Di Aplikasi rekap absensi & jurnal siswa PKL",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Fitur Utama Aplikasi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoute.rekapAbsensi);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.assignment, color: Colors.black),
                                      Text(
                                        "Rekap Absensi",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ))),
                        Card(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoute.rekapJurnal);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.history_edu_outlined, color: Colors.black),
                                      Text(
                                        "Rekap Jurnal",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Card(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRoute.rekapIzin);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_document, color: Colors.black),
                                        Text(
                                          "Rekap Izin",
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ))),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
