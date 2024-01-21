import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pkl_smkn1mejayan_guru/model/absen_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/next_prev_day_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';
import 'package:url_launcher/url_launcher.dart';

import 'component/utility.dart';

class RekapAbsensiPage extends StatefulWidget {
  const RekapAbsensiPage({super.key});
  static const String routeName = '/rekap/absensi';

  @override
  State<RekapAbsensiPage> createState() => _RekapAbsensiView();
}

class _RekapAbsensiView extends State<RekapAbsensiPage> {
  late bool hasAbsen;
  var dataAbsen;
  Uri? changeUrl;

  @override
  void initState() {
    super.initState();
    hasAbsen = true;
  }

  void handleHasAbsen(int theDay) {
    if (theDay > 0) {
      setState(() {
        hasAbsen = false;
      });
    } else if (theDay == 0) {
      setState(() {
        hasAbsen = true;
      });
    }
  }

  void handleChangeUrl(Uri url) {
    print(url);
    setState(() {
      changeUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              const Text("Rekap Absensi", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),),
              Text(
                getDateNow(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Center(
              child: FutureBuilder(
                  future: AbsenModel.getData(changeUrl: changeUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      if (snapshot.data['kelompok'] == null || snapshot.data['kelompok'].isEmpty) {
                        return const Center(child: Text("Anda belum mempunyai kelompok untuk di urus"));
                      } else {
                        return Column(
                          children: [
                            Card(
                              child: DataTableAbsenComponent(
                                  hasAbsen: handleHasAbsen, data: snapshot.data, changeUrl: handleChangeUrl),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                child: TextButton.icon(
                                    onPressed: () {
                                      launchUrl(ApiRoutes.cetakRekabAbsenRoute);
                                    },
                                    icon: const Icon(Icons.print, color: Colors.white),
                                    label: const Text(
                                        "Cetak "
                                        "data absensi",
                                        style: TextStyle(color: Colors.white)),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow))),
                              ),
                            ),
                            if (hasAbsen)
                              Card(
                                  child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Siswa yang belum absen",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                  ),
                                  DataTableDoesntAbsenComponent(namaKelompok: snapshot.data['kelompok_ini']),
                                ],
                              ))
                          ],
                        );
                      }
                    }
                  }),
            ),
          ),
        ),
      ]),
    );
  }
}

class DataTableAbsenComponent extends StatefulWidget {
  DataTableAbsenComponent({super.key, required this.hasAbsen, required this.data, required this.changeUrl});
  GetStorage box = GetStorage();
  void Function(int) hasAbsen;
  void Function(Uri) changeUrl;
  var data;

  @override
  State<DataTableAbsenComponent> createState() =>
      _FetchingDataFragment(hasAbsen: hasAbsen, data: data, changeUrl: changeUrl);
}

class _FetchingDataFragment extends State<DataTableAbsenComponent> {
  _FetchingDataFragment({required this.hasAbsen, required this.data, required this.changeUrl});

  var data;
  Uri? changeAbsen;
  late int theDay;
  String? namaKelompok;
  void Function(int) hasAbsen;
  void Function(Uri) changeUrl;

  @override
  void initState() {
    super.initState();
    theDay = data['hari'];
    namaKelompok = data['kelompok_ini'];
  }

  void changeDay(String day) {
    setState(() {
      (day == 'plus') ? theDay = (theDay + 1) : theDay = (theDay - 1);
      changeUrlAbsen();
      changeUrl(changeAbsen!);
      hasAbsen(theDay);
    });
  }

  void changeUrlAbsen() {
    if (theDay != 0) {
      changeAbsen = Uri.parse("${ApiRoutes.getDataAbsenRoute}/$namaKelompok/$theDay");
    } else {
      changeAbsen = Uri.parse("${ApiRoutes.getDataAbsenRoute}/$namaKelompok");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRow = (data['data'] as List).asMap().entries.map((entry) {
      var dataIni = entry.value;

      return DataRow(cells: <DataCell>[
        DataCell(Text((dataIni['user'] == null)
            ? "Unknown"
            : truncateAndCapitalizeLastWord(dataIni['user']['name'], maxLength: 10))),
        DataCell(checkStatus(data, dataIni)),
        DataCell(Text(formatDate(dataIni['datang']))),
        DataCell(Text((dataIni['pulang'] == null) ? '-' : formatDate(dataIni['pulang']))),
      ]);
    }).toList();

    return Column(
      children: [
        FormBuilder(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
          child: FormBuilderDropdown(
            initialValue: data['kelompok_ini'],
            name: 'tipe_data',
            items: (data['kelompok'] as List).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              setState(() {
                changeUrl(Uri.parse("${ApiRoutes.getDataAbsenRoute}/${value.toString()}"));
              });
            },
          ),
        )),
        Text(convertDayFromNumber(data['hari'])),
        DataTable(columns: const <DataColumn>[
          DataColumn(
              label: Expanded(
                  child: Text(
            "Nama",
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            "Tipe",
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            "Datang",
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
          DataColumn(
              label: Expanded(
                  child: Text(
            "Pulang",
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
        ], rows: dataRow),
        NextPrevDayComponent(prevDay: changeDay, theDay: theDay)
      ],
    );
    // }
  }
}

class DataTableDoesntAbsenComponent extends StatefulWidget {
  DataTableDoesntAbsenComponent({super.key, required this.namaKelompok});
  GetStorage box = GetStorage();
  final namaKelompok;

  @override
  State<DataTableDoesntAbsenComponent> createState() => _FetchingDataDoesntAbsenFragment();
}

class _FetchingDataDoesntAbsenFragment extends State<DataTableDoesntAbsenComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          FutureBuilder(
              future: AbsenModel.getDataDoesntAbsen(widget.namaKelompok),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  print("DATAAA: ${snapshot.data}");
                  if (snapshot.data['data'] == null || snapshot.data['data'].isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Semua siswa sudah absen!!!", style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }
                  List<DataRow> dataRow = (snapshot.data['data'] as List).asMap().entries.map((entry) {
                    var data = entry.value;
                    var index = entry.key + 1;

                    return DataRow(cells: <DataCell>[
                      DataCell(Text(index.toString())),
                      DataCell(Text(data['name'] ?? "")),
                    ]);
                  }).toList();

                  return Container(
                    width: double.infinity,
                    child: DataTable(columns: const <DataColumn>[
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        "#",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        "Nama",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                    ], rows: dataRow),
                  );
                }
              }),
        ],
      ),
    );
  }
}
