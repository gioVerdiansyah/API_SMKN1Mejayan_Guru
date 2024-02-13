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
  Uri? changeUrl;

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
                "Rekap Izin",
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: FutureBuilder(
                future: IzinModel.getData(changeUrl: changeUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.data['kelompok'] == null || snapshot.data['kelompok'].isEmpty) {
                    return const Text("Anda belum mempunyai kelompok untuk di urus");
                  } else {
                    return Column(children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: DataTabeleIzinComponent(data: snapshot.data, changeUrl: handleChangeUrl),
                            ),
                          ),
                        ],
                      )
                    ]);
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

class DataTabeleIzinComponent extends StatefulWidget {
  DataTabeleIzinComponent({super.key, required this.data, required this.changeUrl});
  final data;
  void Function(Uri) changeUrl;

  @override
  State<DataTabeleIzinComponent> createState() => _FetchingDataFragment(data: data, changeUrl: changeUrl);
}

class _FetchingDataFragment extends State<DataTabeleIzinComponent> {
  _FetchingDataFragment({required this.data, required this.changeUrl});
  final data;

  void Function(Uri) changeUrl;
  Uri? changeIzin;
  String? statusIni;
  late String namaKelompok;

  @override
  void initState() {
    super.initState();
    namaKelompok = data['kelompok_ini'];
    statusIni = getNameFromStatus(data['status']);
  }

  String getNameFromStatus(value) {
    switch (value) {
      case '1':
        return 'Disetujui';
      case '2':
        return 'Ditolak';
      default:
        return 'Semua';
    }
  }

  String? getStatus(value) {
    switch (value) {
      case 'Disetujui':
        return '1';
      case 'Ditolak':
        return '2';
      default:
        return '0';
    }
  }

  void handleChangeKelompok(nama_kelompok) {
    setState(() {
      namaKelompok = nama_kelompok;
      changeUrl(Uri.parse("${ApiRoutes.getDataIzinRoute}/$namaKelompok"));
    });
  }

  void handleChangeStatus(status) {
    setState(() {
      statusIni = status;
      changeUrl(Uri.parse("${ApiRoutes.getDataIzinRoute}/$namaKelompok/$statusIni"));
    });
  }

  void handlePaginate(url) {
    setState(() {
      changeUrl(Uri.parse(url));
    });
  }

  Color? setStatusColor(value) {
    switch (value) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRow = (data['data']['data'] as List).asMap().entries.map((entry) {
      var currentData = entry.value;

      return DataRow(cells: <DataCell>[
        DataCell(Text(
          (getNameFromStatus(currentData['status']) == "Semua") ? "Pending" : getNameFromStatus(currentData['status']),
          style: TextStyle(color: setStatusColor(currentData['status'])),
          textAlign: TextAlign.center,
        )),
        DataCell(Text((currentData['user'] == null)
            ? "Unknown"
            : truncateAndCapitalizeLastWord(currentData['user']['name'], maxLength: 10))),
        DataCell(Text(currentData['tipe_izin'])),
        DataCell(TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailIzinPage(data: currentData)));
          },
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
          child: const Text("Detail", style: TextStyle(color: Colors.white)),
        )),
      ]);
    }).toList();

    var page = data['data'];

    // Handle element pagination
    late List<Widget> paginate;
    late MainAxisAlignment handleMainAxis;

    if (page['next_page_url'] != null && page['prev_page_url'] != null) {
      handleMainAxis = MainAxisAlignment.spaceBetween;
      paginate = [
        TextButton(
            onPressed: () {
              handlePaginate(page['prev_page_url']);
            },
            child: const Text("<< Next")),
        TextButton(
            onPressed: () {
              handlePaginate(page['next_page_url']);
            },
            child: const Text("Prev>>"))
      ];
    } else if (page['prev_page_url'] != null) {
      handleMainAxis = MainAxisAlignment.start;
      paginate = [
        TextButton(
            onPressed: () {
              handlePaginate(page['prev_page_url']);
            },
            child: const Text("<< Next"))
      ];
    } else if (page['next_page_url'] != null) {
      handleMainAxis = MainAxisAlignment.end;
      paginate = [
        TextButton(
            onPressed: () {
              handlePaginate(page['next_page_url']);
            },
            child: const Text("Prev>>"))
      ];
    } else {
      handleMainAxis = MainAxisAlignment.start;
      paginate = [TextButton(onPressed: () {}, child: const Text(""))];
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FormBuilder(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: FormBuilderDropdown(
                  name: 'tipe_data',
                  initialValue: namaKelompok,
                  items: (data['kelompok'] as List).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    handleChangeKelompok(value.toString());
                  },
                ),
              )),
            ),
            Expanded(
              child: FormBuilder(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FormBuilderDropdown(
                  name: 'tipe_data',
                  initialValue: statusIni,
                  items: ['Semua', 'Disetujui', 'Ditolak'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    handleChangeStatus(getStatus(value.toString()));
                  },
                ),
              )),
            )
          ],
        ),
        Column(
          children: [
            (data['data']['data'].isEmpty)
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
        )
      ],
    );
  }
}
