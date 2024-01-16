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
    }else if(theDay == 0){
      setState(() {
        hasJurnal = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Center(
            child: Column(
              children: [
                Text(
                  getDateNow(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Card(
                          child: DataTableJurnalComponent(hasJurnal: listSiswaBelumAbsen),
                        ),
                        if (hasJurnal)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Card(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Siswa yang belum mengisi jurnal", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                    )),
                                  ),
                                  DataTableDoesntJurnalComponent()
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DataTableJurnalComponent extends StatefulWidget {
  DataTableJurnalComponent({super.key, required this.hasJurnal});
  void Function(int) hasJurnal;
  GetStorage box = GetStorage();

  @override
  State<DataTableJurnalComponent> createState() => _FetchingDataJurnalFragment(hasJurnal: hasJurnal);
}

class _FetchingDataJurnalFragment extends State<DataTableJurnalComponent> {
  _FetchingDataJurnalFragment({required this.hasJurnal});
  void Function(int) hasJurnal;
  Uri? changeJurnal;
  late int theDay;
  int? setStatus;
  String selectedValue = 'Semua';

  @override
  void initState() {
    super.initState();
    theDay = 0;
  }

  void prevDay(String day) {
    setState(() {
      (day == 'plus') ? theDay = (theDay + 1) : theDay = (theDay - 1);
      changeUrl();
      hasJurnal(theDay);
    });
  }

  void changeUrl() {
    if (setStatus != null) {
      changeJurnal = Uri.parse("${ApiRoutes.jurnalNextPrevDayRoute}/$theDay/$setStatus");
    } else {
      changeJurnal = Uri.parse("${ApiRoutes.jurnalNextPrevDayRoute}/$theDay");
    }
    print(changeJurnal);
  }

  int? getStatus(value) {
    switch (value) {
      case 'Disetujui':
        return 1;
      case 'Ditolak':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
          child: FormBuilderDropdown(
            name: 'tipe_data',
            initialValue: selectedValue,
            items: ['Semua', 'Disetujui', 'Ditolak'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value.toString();
                setStatus = getStatus(value.toString());
                changeUrl();
              });
            },
          ),
        )),
        FutureBuilder(
            future: JurnalModel.getData(changeJurnal),
            builder: (context, snapshoot) {
              if (snapshoot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshoot.hasError) {
                return Text("Error: ${snapshoot.error}");
              } else {
                List<DataRow> dataRow = (snapshoot.data['data'] as List).asMap().entries.map((entry) {
                  var data = entry.value;

                  Color? setStatusColor() {
                    switch (data['status']) {
                      case '1':
                        return Colors.green;
                      case '2':
                        return Colors.red;
                      default:
                        return Colors.black;
                    }
                  }

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(
                      formatDate(data['created_at'], format: 'dd MMM'),
                      style: TextStyle(color: setStatusColor()), textAlign: TextAlign.center,
                    )),
                    DataCell(Text(truncateAndCapitalizeLastWord(data['user']['name'], maxLength: 10))),
                    DataCell(Text(truncateText(data['kegiatan'], 10))),
                    DataCell(TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailJurnalPage(data: data)));
                      },
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
                      child: const Text('Detail', style: TextStyle(color: Colors.white)),
                    )),
                  ]);
                }).toList();

                if (snapshoot.data['data'].isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Belum ada yang mengisi jurnal..."),
                        NextPrevDayComponent(
                          prevDay: prevDay,
                          theDay: theDay,
                        )
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    DataTable(columns: const <DataColumn>[
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
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        "Kegiatan",
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
                      prevDay: prevDay,
                      theDay: theDay,
                    )
                  ],
                );
              }
            }),
      ],
    );
  }
}

class DataTableDoesntJurnalComponent extends StatefulWidget {
  DataTableDoesntJurnalComponent({super.key});
  GetStorage box = GetStorage();

  @override
  State<DataTableDoesntJurnalComponent> createState() => _FetchingDataDoesntJurnalFragment();
}

class _FetchingDataDoesntJurnalFragment extends State<DataTableDoesntJurnalComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: JurnalModel.getDataDoesntJurnal(),
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
                    child: Text("Semua siswa sudah mengisi jurnal!!!", style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
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
    );
  }
}
