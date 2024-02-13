import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/next_prev_day_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/detail_jurnal.dart';
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

import '../../model/jurnal_model.dart';
import 'component/utility.dart';

class RekapJurnalPage extends StatefulWidget {
  const RekapJurnalPage({super.key});
  static const String routeName = '/rekap/jurnal';

  @override
  State<RekapJurnalPage> createState() => _RekapJurnalView();
}

class _RekapJurnalView extends State<RekapJurnalPage> {
  late bool hasJurnal;
  Uri? changeUrl;

  @override
  void initState() {
    super.initState();
    hasJurnal = true;
  }

  void listSiswaBelumAbsen(int theDay) {
    if (theDay > 0) {
      setState(() {
        hasJurnal = false;
      });
    } else if (theDay == 0) {
      setState(() {
        hasJurnal = true;
      });
    }
  }

  void handleChangeUrl(Uri url) {
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
              const Text(
                "Rekap Jurnal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
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
                future: JurnalModel.getData(changeUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.data['kelompok'] == null || snapshot.data['kelompok'].isEmpty) {
                    return const Text("Anda belum mempunyai kelompok untuk di urus");
                  } else {
                    return Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Card(
                                      child: DataTableJurnalComponent(
                                          data: snapshot.data, hasJurnal: listSiswaBelumAbsen, changeUrl: handleChangeUrl),
                                    ),
                                    if (hasJurnal)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Card(
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Siswa yang belum mengisi jurnal",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                              ),
                                              DataTableDoesntJurnalComponent(
                                                namaKelompok: snapshot.data['kelompok_ini'],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                )))
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class DataTableJurnalComponent extends StatefulWidget {
  DataTableJurnalComponent({required this.data, required this.hasJurnal, required this.changeUrl});
  void Function(int) hasJurnal;
  void Function(Uri) changeUrl;
  var data;
  GetStorage box = GetStorage();

  @override
  State<DataTableJurnalComponent> createState() =>
      _FetchingDataJurnalFragment(data: data, hasJurnal: hasJurnal, changeUrl: changeUrl);
}

class _FetchingDataJurnalFragment extends State<DataTableJurnalComponent> {
  _FetchingDataJurnalFragment({required this.data, required this.hasJurnal, required this.changeUrl});
  void Function(int) hasJurnal;
  void Function(Uri) changeUrl;
  var data;
  late int theDay;
  String? setStatus;
  Uri? urlSaatIni;
  late String selectedValue;
  late String namaKelompok;

  @override
  void initState() {
    super.initState();
    theDay = data['hari'];
    namaKelompok = data['kelompok_ini'];
    setStatus = data['status'];
    selectedValue = getNameFromStatus(data['status']);
  }

  void changeDay(String day) {
    setState(() {
      (day == 'plus') ? theDay = (theDay + 1) : theDay = (theDay - 1);
      changeJurnal();
      changeUrl(urlSaatIni!);
      hasJurnal(theDay);
    });
  }

  void changeJurnal() {
    if (setStatus != null) {
      urlSaatIni = Uri.parse("${ApiRoutes.getDataJurnalRoute}/$namaKelompok/$theDay/$setStatus");
    } else {
      urlSaatIni = Uri.parse("${ApiRoutes.getDataJurnalRoute}/$namaKelompok/$theDay");
    }
  }

  String getStatus(value) {
    switch (value) {
      case 'Disetujui':
        return '1';
      case 'Ditolak':
        return '2';
      case 'Menunggu':
        return '0';
      default:
        return "NaV";
    }
  }

  String getNameFromStatus(value) {
    switch (value) {
      case '1':
        return 'Disetujui';
      case '2':
        return 'Ditolak';
      case '0':
        return 'Menunggu';
      default:
        return 'Semua';
    }
  }

  Color? setStatusColor(data) {
    switch (data) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.red;
      case '0':
        return Colors.yellow;
      default:
        return Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRow = (data['data'] as List).asMap().entries.map((entry) {
      var data = entry.value;

      return DataRow(cells: <DataCell>[
        DataCell(Text(truncateAndCapitalizeLastWord(data['user']['name'], maxLength: 15))),
        DataCell(Text(
          (getNameFromStatus(data['status']) == 'Semua') ? 'Pending' : getNameFromStatus(data['status']),
          style: TextStyle(color: setStatusColor(data['status'])),
        )),
        DataCell(TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailJurnalPage(data: data)));
          },
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
          child: const Text('Detail', style: TextStyle(color: Colors.white)),
        )),
      ]);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FormBuilder(
                      child: FormBuilderDropdown(
                    name: 'kelompok',
                    initialValue: namaKelompok,
                    items: (data['kelompok'] as List).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) {
                      setState(() {
                        namaKelompok = value.toString();
                        changeUrl(Uri.parse(
                            "${ApiRoutes.getDataJurnalRoute}/$namaKelompok/$theDay/${getStatus(selectedValue)}"));
                      });
                    },
                  )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FormBuilder(
                      child: FormBuilderDropdown(
                    name: 'tipe_data',
                    initialValue: selectedValue,
                    items: ['Semua', 'Menunggu', 'Disetujui', 'Ditolak']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                        setStatus = getStatus(value.toString());
                        changeUrl(Uri.parse("${ApiRoutes.getDataJurnalRoute}/$namaKelompok/$theDay/$setStatus"));
                      });
                    },
                  )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(convertDayFromNumber(data['hari'])),
        ),
        Column(
          children: [
            (data['data'].isEmpty)
                ? const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Tidak ada data...",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : DataTable(columns: const <DataColumn>[
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Nama",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Aksi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                  ], rows: dataRow),
            NextPrevDayComponent(
              prevDay: changeDay,
              theDay: theDay,
            )
          ],
        )
      ],
    );
  }
}

class DataTableDoesntJurnalComponent extends StatefulWidget {
  DataTableDoesntJurnalComponent({super.key, required this.namaKelompok});
  GetStorage box = GetStorage();
  final String namaKelompok;

  @override
  State<DataTableDoesntJurnalComponent> createState() => _FetchingDataDoesntJurnalFragment(namaKelompok: namaKelompok);
}

class _FetchingDataDoesntJurnalFragment extends State<DataTableDoesntJurnalComponent> {
  _FetchingDataDoesntJurnalFragment({required this.namaKelompok});
  final String namaKelompok;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          FutureBuilder(
              future: JurnalModel.getDataDoesntJurnal(namaKelompok),
              builder: (context, snapshoot) {
                if (snapshoot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshoot.hasError) {
                  return Text("Error: ${snapshoot.error}");
                } else {
                  List<DataRow> dataRow = (snapshoot.data['data'] as List).asMap().entries.map((entry) {
                    var data = entry.value;
                    var index = entry.key + 1;

                    return DataRow(cells: <DataCell>[
                      DataCell(Text(index.toString())),
                      DataCell(Text(data['name'])),
                    ]);
                  }).toList();

                  if (snapshoot.data['data'].isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Semua siswa sudah mengisi jurnal!!!", style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }

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
