import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkl_smkn1mejayan_guru/model/izin_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';

import 'component/utility.dart';

class RekapIzinPage extends StatefulWidget{
  const RekapIzinPage({super.key});
  static const String routeName = '/rekap/izin';

  @override
  State<RekapIzinPage> createState() => _RekapJurnalView();
}

class _RekapJurnalView extends State<RekapIzinPage>{
  @override
  Widget build(BuildContext context){
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
                Padding(padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: DataTabeleIzinComponent(),
                ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

class DataTabeleIzinComponent extends StatefulWidget{
  DataTabeleIzinComponent({super.key});

  @override
  State<DataTabeleIzinComponent> createState() => _FetchingDataFragment();
}

class _FetchingDataFragment extends State<DataTabeleIzinComponent>{
  Uri? changeIzin;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: IzinModel.getData(changeUrl: changeIzin),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                List<DataRow> dataRow = (snapshot.data['izin']['data']['data'] as List).asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  var data = entry.value;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(index.toString())),
                    DataCell(Text((data['user'] == null) ? "Unknown" : truncateAndCapitalizeLastWord
                      (data['user']['name'],maxLength: 10))),
                    DataCell(Text(capitalizeFirstLetter(data['tipe']))),
                    DataCell(Text(formatDate(data['created_at']))),
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
                        child: const Text("<< Prev day")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            changeIzin = Uri.parse(page['next_page_url']);
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
                            changeIzin = Uri.parse(page['prev_page_url']);
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
                            changeIzin = Uri.parse(page['next_page_url']);
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