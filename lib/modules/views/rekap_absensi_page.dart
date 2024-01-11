import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pkl_smkn1mejayan_guru/model/absen_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Center(
            child: Column(
              children: [
                Text(
                  getDateNow(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: DataTableAbsenComponent(hasAbsen: handleHasAbsen),
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
                            DataTableDoesntAbsenComponent(),
                          ],
                        ))
                    ],
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

class DataTableAbsenComponent extends StatefulWidget {
  DataTableAbsenComponent({super.key, required this.hasAbsen});
  GetStorage box = GetStorage();
  void Function(int) hasAbsen;

  @override
  State<DataTableAbsenComponent> createState() => _FetchingDataFragment(hasAbsen: hasAbsen);
}

class _FetchingDataFragment extends State<DataTableAbsenComponent> {
  _FetchingDataFragment({required this.hasAbsen});
  Uri? changeAbsen;
  late int theDay;
  int? setStatus;
  void Function(int) hasAbsen;
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    theDay = 0;
  }

  void prevDay(String day) {
    setState(() {
      (day == 'plus') ? theDay = (theDay + 1) : theDay = (theDay - 1);
      changeUrl();
      hasAbsen(theDay);
    });
  }

  void changeUrl() {
    if (setStatus != null) {
      changeAbsen = Uri.parse("${dotenv.get('API_URL')}/absen/prev_day/$theDay/$setStatus");
    } else {
      changeAbsen = Uri.parse("${dotenv.get('API_URL')}/absen/prev_day/$theDay");
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
            initialValue: (selectedValue != 'Absensi Kehadiran') ? 'Absensi Kehadiran' : 'Absensi Pulang',
            items: ['Absensi Kehadiran', 'Absensi Pulang'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value.toString();
                changeAbsen = (selectedValue == 'Absensi Kehadiran')
                    ? ApiRoutes.getDataAbsenRoute
                    : ApiRoutes.getDataAbsenPulangRoute;
              });
            },
          ),
        )),
        FutureBuilder(
            future: AbsenModel.getData(changeAbsen),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                List<DataRow> dataRow = (snapshot.data['absen']['data']['data'] as List).asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  var data = entry.value;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(index.toString())),
                    DataCell(Text((data['user'] == null)
                        ? "Unknown"
                        : truncateAndCapitalizeLastWord(data['user']['name'], maxLength: 10))),
                    DataCell(Text(capitalizeFirstLetter(data['status']))),
                    DataCell(Text(formatDate(data['created_at']))),
                  ]);
                }).toList();

                if (snapshot.data['absen']['data']['data'].isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Belum ada yang absen..."),
                  );
                }

                // Handle element pagination
                late List<Widget> paginate;
                late MainAxisAlignment handleMainAxis;

                var page = snapshot.data['absen']['data'];
                if (page['next_page_url'] != null && page['prev_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.spaceBetween;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeAbsen = Uri.parse(page['prev_page_url']);
                          });
                        },
                        child: const Text("<< Prev day")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeAbsen = Uri.parse(page['next_page_url']);
                          });
                        },
                        child: const Text("Next day >>"))
                  ];
                } else if (page['prev_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.start;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeAbsen = Uri.parse(page['prev_page_url']);
                          });
                        },
                        child: const Text("<< Prev day"))
                  ];
                } else if (page['next_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.end;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeAbsen = Uri.parse(page['next_page_url']);
                          });
                        },
                        child: const Text("Next day >>"))
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
                        "Tanggal",
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

class DataTableDoesntAbsenComponent extends StatefulWidget {
  DataTableDoesntAbsenComponent({super.key});
  GetStorage box = GetStorage();

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
              future: AbsenModel.getDataDoesntAbsen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  if (snapshot.data['absen']['data'].isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Semua siswa sudah absen!!!", style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }
                  List<DataRow> dataRow = (snapshot.data['absen']['data'] as List).asMap().entries.map((entry) {
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
