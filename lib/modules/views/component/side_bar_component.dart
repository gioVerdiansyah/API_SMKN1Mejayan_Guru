import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/utility.dart';

import '../../../routes/app_route.dart';
import '../login_page.dart';

class SideBarComponent extends StatefulWidget {
  const SideBarComponent({super.key});

  @override
  State<SideBarComponent> createState() => _SideBarView();
}

class _SideBarView extends State<SideBarComponent> {
  @override
  Widget build(BuildContext context) {
    final GetStorage box = GetStorage();
    final guru = box.read('dataLogin')['login']['guru'] ?? "";
    void NavigasiKe(routeName) {
      if (ModalRoute.of(context)?.settings.name != routeName) {
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
                  Image.network(
                    guru['jurusan']['gambar'],
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
                          "${truncateAndCapitalizeLastWord(guru['nama'])} ${guru['gelar']}",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 2.0,
                          width: 160.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ketua Jurusan ${guru['jurusan']['jurusan']}',
                          style: const TextStyle(fontSize: 15, color: Colors.white),
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
          ListTile(
            title: const Text("Rekap Absensi"),
            onTap: () {
              NavigasiKe(AppRoute.rekapAbsensi);
            },
          ),ListTile(
            title: const Text("Rekap Jurnal"),
            onTap: () {
              NavigasiKe(AppRoute.rekapJurnal);
            },
          ),ListTile(
            title: const Text("Rekap Izin"),
            onTap: () {
              NavigasiKe(AppRoute.rekapIzin);
            },
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () async {
              ArtDialogResponse response = await ArtSweetAlert.show(
                  barrierDismissible: false,
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      denyButtonText: "Batal",
                      title: "Apakah Anda yakin?",
                      confirmButtonText: "Ya, logout",
                      type: ArtSweetAlertType.warning));

              if (response == null) {
                return;
              }

              if (response.isTapConfirmButton) {
                GetStorage().erase();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
