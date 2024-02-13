import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkl_smkn1mejayan_guru/model/absen_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';

class AbsenBermasalahPage extends StatefulWidget {
  AbsenBermasalahPage({super.key});
  static const String routeName = '/absen-trouble';

  @override
  State<AbsenBermasalahPage> createState() => _AbsenBermasalahView();
}

class _AbsenBermasalahView extends State<AbsenBermasalahPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late String tipeKehadiran;
  late String namaSiswa;

  // Tambahkan variabel untuk menyimpan hasil fetching data
  List<dynamic>? anggotaData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  "Absensi bermasalah pada siswa",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Periksa apakah data sudah diambil sebelumnya
                      if (anggotaData == null)
                        FutureBuilder(
                          future: AbsenModel.getAnggota(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              if (snapshot.data['data'] == null || snapshot.data['data'].isEmpty) {
                                return Center(child: Text(snapshot.data['message']));
                              } else {
                                // Simpan hasil fetching data dalam variabel
                                anggotaData = snapshot.data['data'];
                                namaSiswa = anggotaData?[0];

                                return FormBuilderDropdown(
                                  name: 'nama-siswa-1',
                                  initialValue: anggotaData?[0],
                                  decoration: InputDecoration(
                                    labelText: "Nama Siswa",
                                  ),
                                  items: (anggotaData as List)
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      namaSiswa = value.toString();
                                    });
                                  },
                                );
                              }
                            }
                          },
                        )
                      else
                        FormBuilderDropdown(
                          name: 'nama-siswa-2',
                          initialValue: anggotaData?[0],
                          decoration: InputDecoration(
                            labelText: "Nama Siswa",
                          ),
                          items: (anggotaData as List).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (value) {
                            setState(() {
                              namaSiswa = value.toString();
                            });
                          },
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: FormBuilderDropdown(
                          name: 'tipe-kehadiran',
                          initialValue: '-- Pilih Tipe Kehadiran --',
                          decoration: InputDecoration(
                            labelText: "Tipe Kehadiran",
                          ),
                          items: ['-- Pilih Tipe Kehadiran --', 'Hadir', 'WFH', 'Cuti']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              tipeKehadiran = value.toString();
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.notEqual('-- Pilih Tipe Kehadiran --'),
                          ]),
                        ),
                      ),
                      Card(
                          color: Colors.green,
                          margin: EdgeInsets.only(top: 20),
                          child: TextButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Text('Processing Data'),
                                    backgroundColor: Colors.green.shade300,
                                  ));

                                  var response = await AbsenModel.absenTrouble(namaSiswa, tipeKehadiran);
                                  if (response['success']) {
                                    if (context.mounted) {
                                      ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.success,
                                            title: "Berhasil!",
                                            text: response['message']),
                                      );
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
                                  _formKey.currentState?.reset();
                                }
                              },
                              icon: const Icon(Icons.send, color: Colors.white),
                              label: const Text(
                                "Absenkan!",
                                style: TextStyle(color: Colors.white),
                              )))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
