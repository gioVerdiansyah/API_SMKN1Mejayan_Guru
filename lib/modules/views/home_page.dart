import 'package:animate_do/animate_do.dart';
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
    final dataLogin = widget.box.read('dataLogin');
    final guru = dataLogin['guru'] ?? "";
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: ListView(children: [
        Container(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Column(
              children: [
                Column(
                  children: [
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Selamat datang ",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${truncateAndCapitalizeLastWord(guru['nama'])}",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 500),
                      from: 30,
                      child: const Text(
                        "Di Aplikasi rekap absensi & jurnal siswa PKL",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 1000),
                      from: 20,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Mengampu",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Text(
                                dataLogin['mengampu']['siswa'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Text("Siswa"),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 3),
                              child: Text(
                                dataLogin['mengampu']['kelompok'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Text("Kelompok"),
                          ],
                        ),
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 1500),
                      from: 50,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Fitur Utama Aplikasi",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 500),
                      from: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Card(
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
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 1000),
                      from: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Card(
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
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 1500),
                      from: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Card(
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
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      delay: const Duration(milliseconds: 2000),
                      from: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Card(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoute.absenTrouble);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.troubleshoot, color: Colors.black),
                                      Text(
                                        "Absen Bermasalah",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ))),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
