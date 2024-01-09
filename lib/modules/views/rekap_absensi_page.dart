import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/model/get_data_absen_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

import 'component/utility.dart';

class RekapAbsensiPage extends StatefulWidget {
  const RekapAbsensiPage({super.key});
  static const String routeName = '/rekap/absensi';

  @override
  State<RekapAbsensiPage> createState() => _RekapAbsensiView();
}

class _RekapAbsensiView extends State<RekapAbsensiPage> {
  List<dynamic> dataAbsensi = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var data = await GetDataAbsenModal.getData(ApiRoutes.getDataAbsenRoute);
    setState(() {
      dataAbsensi = data['absen']['data']['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                Text(
                  getDateNow(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        DataTableAbsenComponent(),
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

class DataTableAbsenComponent extends StatefulWidget {
  DataTableAbsenComponent({super.key});
  GetStorage box = GetStorage();

  @override
  State<DataTableAbsenComponent> createState() => _FetchingDataFragment();
}

class _FetchingDataFragment extends State<DataTableAbsenComponent> {
  Uri? changeAbsen;
  String selectedValue = '';
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
                items: ['Absensi Kehadiran', 'Absensi Pulang']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
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
            future: GetDataAbsenModal.getData(changeAbsen),
            builder: (context, snapshoot) {
              if (snapshoot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshoot.hasError) {
                return Text("Error: ${snapshoot.error}");
              } else {
                  print("Snapshot: ${snapshoot.data}");
                List<DataRow> dataRow = (snapshoot.data['absen']['data']['data'] as List).asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  var data = entry.value;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(index.toString())),
                    DataCell(Text(data['user']['name'])),
                    DataCell(Text(capitalizeFirstLetter(data['status']))),
                    DataCell(Text(formatDate(data['created_at']))),
                  ]);
                }).toList();

                if (snapshoot.data['absen']['data']['data'].isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Belum ada yang absen..."),
                  );
                }

                // Handle element pagination
                late List<Widget> paginate;
                late MainAxisAlignment handleMainAxis;

                var page = snapshoot.data['absen']['data'];
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
                }else{
                  handleMainAxis = MainAxisAlignment.start;
                  paginate = [
                    TextButton(
                        onPressed: () {},
                        child: const Text(""))
                  ];
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