import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pkl_smkn1mejayan_guru/env.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/description_text_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/utility.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/rekap_izin_page.dart';
import 'package:pkl_smkn1mejayan_guru/routes/app_route.dart';

import '../../model/izin_model.dart';

class DetailIzinPage extends StatefulWidget {
  DetailIzinPage({required this.data});
  final Map<String, dynamic> data;
  static const String routeName = '/detail_jurnal';

  @override
  State<DetailIzinPage> createState() => _DetailIzinView();
}

class _DetailIzinView extends State<DetailIzinPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController keterangan = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.data;
    return Scaffold(
      appBar: const AppBarComponent(),
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      "Detail izin Siswa ${truncateAndCapitalizeLastWord(data['user']['name'])}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bukti Izin:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Center(
                            child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2)),
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/images/loading.gif'),
                                  image: NetworkImage("${Env.STORAGE_URL}/${data['bukti']}"),
                                  width: 300,
                                ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Alasan izin:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                DescriptionText(
                                  alasan: data['alasan'],
                                  maxLength: 400,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Tanggal izin: ", style: TextStyle(color: Color.fromRGBO(52, 53, 65, 1))),
                                          Text(
                                            formatDate(data['created_at'], format: 'd MMMM yyyy'),
                                            style: const TextStyle(color: Color.fromRGBO(52, 53, 65, 1)),
                                          )
                                        ],
                                      ),
                                    ),Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Izin selama: ", style: TextStyle(color: Color.fromRGBO(52, 53, 65, 
                                              1))),
                                          Text(
                                            getDifferentDayInInt(data['awal_izin'], data['akhir_izin']),
                                            style: const TextStyle(color: Color.fromRGBO(52, 53, 65, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.green,
                                  thickness: 2,
                                ),
                                const Center(
                                    child: Text(
                                  "Persetujuan Anda",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                )),
                                (data['status'] == '0')
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: FormBuilder(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              FormBuilderTextField(
                                                name: 'textareafiled',
                                                maxLines: 5,
                                                decoration: const InputDecoration(
                                                  labelText: "Keterangan (opsional)",
                                                  hintText: 'Alasan Anda menyetujui atau menolaknya',
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.green,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                ),
                                                controller: keterangan,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextButton.icon(
                                                        onPressed: () async {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: const Text('Processing Data'),
                                                            backgroundColor: Colors.green.shade300,
                                                          ));
                                                          var response = await IzinModel.agreementIzin(
                                                              data['id'], keterangan.text, 1);
                                                          if (response['success']) {
                                                            if (context.mounted) {
                                                              ArtSweetAlert.show(
                                                                  context: context,
                                                                  artDialogArgs: ArtDialogArgs(
                                                                      type: ArtSweetAlertType.success,
                                                                      title: "Berhasil!",
                                                                      text: response['message'],
                                                                      onConfirm: () {
                                                                        Navigator.pop(context, true);
                                                                      }),
                                                                  barrierDismissible: false);
                                                            }
                                                          } else {
                                                            if (context.mounted) {
                                                              ArtSweetAlert.show(
                                                                context: context,
                                                                artDialogArgs: ArtDialogArgs(
                                                                  type: ArtSweetAlertType.danger,
                                                                  title: "Gagal!",
                                                                  text: response['message'],
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                                                        label: const Padding(
                                                          padding: EdgeInsets.all(10),
                                                          child: Text("Setujui", style: TextStyle(color: Colors.white)),
                                                        ),
                                                        style: const ButtonStyle(
                                                            backgroundColor: MaterialStatePropertyAll(Colors.green))),
                                                    TextButton.icon(
                                                        onPressed: () async {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: const Text('Processing Data'),
                                                            backgroundColor: Colors.green.shade300,
                                                          ));
                                                          var response = await IzinModel.agreementIzin(
                                                              data['id'], keterangan.text, 2);
                                                          if (response['success']) {
                                                            if (context.mounted) {
                                                              ArtSweetAlert.show(
                                                                  context: context,
                                                                  artDialogArgs: ArtDialogArgs(
                                                                      type: ArtSweetAlertType.success,
                                                                      title: "Berhasil!",
                                                                      text: response['message'],
                                                                      onConfirm: () {
                                                                        Navigator.pushNamed(context, AppRoute.rekapIzin);
                                                                      }),
                                                                  barrierDismissible: false);
                                                            }
                                                          } else {
                                                            if (context.mounted) {
                                                              ArtSweetAlert.show(
                                                                context: context,
                                                                artDialogArgs: ArtDialogArgs(
                                                                  type: ArtSweetAlertType.danger,
                                                                  title: "Gagal!",
                                                                  text: response['message'],
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                                                        label: const Padding(
                                                          padding: EdgeInsets.all(10),
                                                          child: Text("Tolak", style: TextStyle(color: Colors.white)),
                                                        ),
                                                        style: const ButtonStyle(
                                                            backgroundColor: MaterialStatePropertyAll(Colors.deepOrange))),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: TextButton.icon(
                                                    onPressed: () async {
                                                      ArtDialogResponse response = await ArtSweetAlert.show(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          artDialogArgs: ArtDialogArgs(
                                                              denyButtonText: "Cancel",
                                                              title: "Apakah Anda yakin?",
                                                              text:
                                                                  "Menolak paksa akan membuat absen siswa yang izin di atas "
                                                                  "akan "
                                                                  "menjadi ALPHA!",
                                                              confirmButtonText: "Yes",
                                                              type: ArtSweetAlertType.warning));

                                                      if (response == null) {
                                                        return;
                                                      }

                                                      if (response.isTapConfirmButton) {
                                                        var response = await IzinModel.tolakPaksa(data['id']);
                                                        if (response['success']) {
                                                          ArtSweetAlert.show(
                                                              context: context,
                                                              artDialogArgs: ArtDialogArgs(
                                                                type: ArtSweetAlertType.success,
                                                                title: "Berhasil!",
                                                                text: response['message'],
                                                                onConfirm: () {
                                                                  Navigator.pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => RekapIzinPage()),
                                                                    (route) => false,
                                                                  );
                                                                },
                                                              ));
                                                        } else {
                                                          ArtSweetAlert.show(
                                                              context: context,
                                                              artDialogArgs: ArtDialogArgs(
                                                                type: ArtSweetAlertType.danger,
                                                                title: "Gagal!",
                                                                text: response['message'],
                                                              ));
                                                        }
                                                        return;
                                                      }
                                                    },
                                                    icon: Icon(Icons.close_rounded, color: Colors.white),
                                                    label: const Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: Text("Tolak Paksa", style: TextStyle(color: Colors.white)),
                                                    ),
                                                    style: const ButtonStyle(
                                                        backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Izin telah "),
                                                Text((data['status'] == '1') ? 'disetujui' : 'ditolak',
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            const Text(
                                              "Catatan Anda:",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            (data['comment_guru'] != null)
                                                ? DescriptionText(
                                                    alasan: data['comment_guru'],
                                                    maxLength: 400,
                                                  )
                                                : const Text("Tidak ada catatan...")
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
