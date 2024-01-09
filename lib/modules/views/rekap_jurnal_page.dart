import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/detail_jurnal.dart';
import 'package:pkl_smkn1mejayan_guru/routes/app_route.dart';

import '../../model/get_data_absen_model.dart';
import '../../model/jurnal_model.dart';
import '../../routes/api_route.dart';
import 'component/utility.dart';

class RekapJurnalPage extends StatefulWidget {
  const RekapJurnalPage({super.key});
  static const String routeName = '/rekap/jurnal';

  @override
  State<RekapJurnalPage> createState() => _RekapJurnalView();
}

class _RekapJurnalView extends State<RekapJurnalPage> {
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
  Uri? changeJurnal;
  String selectedValue = 'Semua';
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
                changeJurnal = getUrl(selectedValue);
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
                List<DataRow> dataRow = (snapshoot.data['jurnal']['data']['data'] as List).asMap().entries.map((entry) {
                  print(snapshoot.data);
                  int index = entry.key + 1;
                  var data = entry.value;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(index.toString())),
                    DataCell(Text(data['user']['name'])),
                    DataCell(Text(truncateText(data['kegiatan'], 10))),
                    DataCell(TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailJurnalPage(data: data)));
                      },
                      child: const Text('Detail', style: TextStyle(color: Colors.white)),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
                    )),
                  ]);
                }).toList();

                if (snapshoot.data['jurnal']['data']['data'].isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Belum ada yang mengisi jurnal..."),
                  );
                }

                // Handle element pagination
                late List<Widget> paginate;
                late MainAxisAlignment handleMainAxis;

                var page = snapshoot.data['jurnal']['data'];
                if (page['next_page_url'] != null && page['prev_page_url'] != null) {
                  handleMainAxis = MainAxisAlignment.spaceBetween;
                  paginate = [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeJurnal = Uri.parse(page['prev_page_url']);
                          });
                        },
                        child: const Text("<< Prev day")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeJurnal = Uri.parse(page['next_page_url']);
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
                            changeJurnal = Uri.parse(page['prev_page_url']);
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
                            changeJurnal = Uri.parse(page['next_page_url']);
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
                        "Kegitan",
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

  Uri? getUrl(value) {
    switch (value) {
      case 'Disetujui':
        return ApiRoutes.getDataJurnalRoute;
      case 'Ditolak':
        return ApiRoutes.getDataJurnalSetujuiRoute;
      default:
        return ApiRoutes.getDataJurnalTolakRoute;
    }
  }
}
