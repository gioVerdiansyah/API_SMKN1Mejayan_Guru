import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pkl_smkn1mejayan_guru/env.dart';
import 'package:pkl_smkn1mejayan_guru/model/jurnal_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/description_text_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/utility.dart';
import 'package:pkl_smkn1mejayan_guru/routes/app_route.dart';

class DetailJurnalPage extends StatefulWidget {
  DetailJurnalPage({required this.data});
  final Map<String, dynamic> data;
  static const String routeName = '/detail_jurnal';

  @override
  State<DetailJurnalPage> createState() => _DetailJurnalView();
}

class _DetailJurnalView extends State<DetailJurnalPage> {
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
                      "Detail Jurnal Siswa ${truncateAndCapitalizeLastWord(data['user']['name'])}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bukti Jurnal:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  border: data['bukti'] != null
                                      ? Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  )
                                      : null,
                                ),
                                child: (data['bukti'] == null)
                                    ? const Text('No Image...')
                                    : Image.network("${Env.STORAGE_URL}/${data['bukti']}", width: 200)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Uraian Kegiatan:", style: TextStyle(fontSize: 15, fontWeight: FontWeight
                                    .bold)),
                                DescriptionText(
                                  alasan: data['kegiatan'],
                                  maxLength: 400,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Dibuat pada: ", style: TextStyle(color: Color.fromRGBO(52, 53, 65, 1))),
                                      Text(
                                        formatDate(data['created_at'], format: 'd MMMM yyyy'),
                                        style: const TextStyle(color: Color.fromRGBO(52, 53, 65, 1)),
                                      )
                                    ],
                                  ),
                                ),
                                if (data['status'] != '3')
                                  Column(
                                    children: [
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
                                                                var response = await JurnalModel.agreementJurnal(
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
                                                                              Navigator.pushNamed(
                                                                                  context, AppRoute.rekapJurnal);
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
                                                              icon: const Icon(Icons.check_circle_outline,
                                                                  color: Colors.white),
                                                              label: const Padding(
                                                                padding: EdgeInsets.all(10),
                                                                child:
                                                                    Text("Setujui", style: TextStyle(color: Colors.white)),
                                                              ),
                                                              style: const ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(Colors.green))),
                                                          TextButton.icon(
                                                              onPressed: () async {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: const Text('Processing Data'),
                                                                  backgroundColor: Colors.green.shade300,
                                                                ));
                                                                var response = await JurnalModel.agreementJurnal(
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
                                                                              Navigator.pushNamed(
                                                                                  context, AppRoute.rekapJurnal);
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
                                                                child:
                                                                    Text("Tolak", style: TextStyle(color: Colors.white)),
                                                              ),
                                                              style: const ButtonStyle(
                                                                  backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                                        ],
                                                      ),
                                                    ),
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
                                                      const Text("Jurnal telah "),
                                                      Text((data['status'] == '1') ? 'disetujui' : 'ditolak',
                                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  const Text(
                                                    "Catatan Anda:",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  (data['keterangan'] != null)
                                                      ? DescriptionText(
                                                          alasan: data['keterangan'],
                                                          maxLength: 400,
                                                        )
                                                      : const Text("Tidak ada catatan...")
                                                ],
                                              ),
                                            )
                                    ],
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
