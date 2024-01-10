import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/next_prev_day_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/detail_jurnal.dart';

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
    });
  }

  void changeUrl() {
    if(setStatus != null){
      changeJurnal = Uri.parse("${dotenv.get('API_URL')}/jurnal/prev_day/$theDay/$setStatus");
    }else{
      changeJurnal = Uri.parse("${dotenv.get('API_URL')}/jurnal/prev_day/$theDay");
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
                List<DataRow> dataRow = (snapshoot.data['jurnal']['data'] as List)
                    .asMap()
                    .entries
                    .map((entry) {
                  var data = entry.value;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(formatDate(data['created_at'], format: 'dd MMM'), textAlign: TextAlign.center,)),
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

                if (snapshoot.data['jurnal']['data'].isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Belum ada yang mengisi jurnal..."),
                        NextPrevDayComponent(prevDay: prevDay, theDay: theDay,)
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
                    NextPrevDayComponent(prevDay: prevDay, theDay: theDay,)
                  ],
                );
              }
            }),
      ],
    );
  }
}
