import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_route.dart';

class SideBarComponent extends StatefulWidget{
  const SideBarComponent({super.key});

  @override
  State<SideBarComponent> createState() => _SideBarView();
}

class _SideBarView extends State<SideBarComponent>{
  @override
  Widget build(BuildContext context){
    final GetStorage box = GetStorage();
    final guru = box.read('dataLogin')['login'] ?? "";
    void NavigasiKe(routeName){
      if(ModalRoute.of(context)?.settings.name != routeName) {
        Navigator.pushNamed(context, routeName);
      }
    }
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/jurusan/${box.read('dataLogin')['guru']['jurusan']['jurusan']}.png',
                    width: 75,
                    height: 75,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          guru['nama'],
                          style: TextStyle(fontSize: guru['nama'].length * 3.8, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 2.0,
                          width: 150.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${guru['jurusan']['jurusan']}',
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          ListTile(
            title: const Text("Home"),
            onTap: () {
              NavigasiKe(AppRoute.homeRoute);
            },
          ),
        ],
      ),
    );
  }
}