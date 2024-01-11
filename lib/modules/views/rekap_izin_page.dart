import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pkl_smkn1mejayan_guru/model/izin_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/detail_izin.dart';

import '../../routes/api_route.dart';
import 'component/utility.dart';

class RekapIzinPage extends StatefulWidget {
  const RekapIzinPage({super.key});
  static const String routeName = '/rekap/izin';

  @override
  State<RekapIzinPage> createState() => _RekapJurnalView();
}

class _RekapJurnalView extends State<RekapIzinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                children: [
                  Text(
                    getDateNow(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: DataTabeleIzinComponent(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.print, color: Colors.white),
                                  label: const Text(
                                      "Cetak "
                                      "data izin per bulan",
                                      style: TextStyle(color: Colors.white)),
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow))),
                            ),
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.print, color: Colors.white),
                                  label: const Text(
                                      "Cetak semua "
                                      "data izin",
                                      style: TextStyle(color: Colors.white)),
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow))),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class DataTabeleIzinComponent extends StatefulWidget {
  DataTabeleIzinComponent({super.key});

  @override
  State<DataTabeleIzinComponent> createState() => _FetchingDataFragment();
}

class _FetchingDataFragment extends State<DataTabeleIzinComponent> {
  Uri? changeIzin;
  int? setStatus;
  late int theDay;
  String selectedValue = 'Semua';

  @override
  void initState() {
    super.initState();
    theDay = 0;
  }

  int? getStatus(value) {
    switch (value) {
      case 'Disetujui':
        changeIzin = Uri.parse("${ApiRoutes.getDataIzinRoute}/1");
        return 1;
      case 'Ditolak':
        changeIzin = Uri.parse("${ApiRoutes.getDataIzinRoute}/2");
        return 2;
      default:
        changeIzin = ApiRoutes.getDataIzinRoute;
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
              });
            },
          ),
        )),
        FutureBuilder(
            future: IzinModel.getData(changeUrl: changeIzin),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                List<DataRow> dataRow = (snapshot.data['izin']['data']['data'] as List).asMap().entries.map((entry) {
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
                      style: TextStyle(color: setStatusColor()),
                    )),
                    DataCell(Text((data['user'] == null)
                        ? "Unknown"
                        : truncateAndCapitalizeLastWord(data['user']['name'], maxLength: 10))),
                    DataCell(Text(data['tipe_izin'])),
                    DataCell(TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailIzinPage(data: data)));
                      },
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
                      child: const Text("Detail", style: TextStyle(color: Colors.white)),
                    )),
                  ]);
                }).toList();

                var page = snapshot.data['izin']['data'];
                if (snapshot.data['izin']['data']['data'].isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Belum ada yang izin pada ${page['per_page']} data terakhir..."),
                  );
                }

                // Handle element pagination
                late List<Widget> paginate;
                late MainAxisAlignment handleMainAxis;

                if (page['next_page_url'] != null && page['prev_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.spaceBetween;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeIzin = Uri.parse(page['prev_page_url']);
                          });
                        },
                        child: const Text("<< Prev")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeIzin = Uri.parse(page['next_page_url']);
                          });
                        },
                        child: const Text("Next>>"))
                  ];
                } else if (page['prev_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.start;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeIzin = Uri.parse(page['prev_page_url']);
                          });
                        },
                        child: const Text("<< Prev"))
                  ];
                } else if (page['next_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.end;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeIzin = Uri.parse(page['next_page_url']);
                          });
                        },
                        child: const Text("Next>>"))
                  ];
                } else {
                  handleMainAxis = MainAxisAlignment.start;
                  paginate = [TextButton(onPressed: () {}, child: const Text(""))];
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
                        "Tipe",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                      DataColumn(
                          label: Expanded(
                              child: Text(
                        "Aksi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                    ], rows: dataRow),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: handleMainAxis, children: paginate),
                    )
                  ],
                );
              }
            }),
      ],
    );
  }
}
