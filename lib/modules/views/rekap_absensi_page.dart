import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pkl_smkn1mejayan_guru/model/get_data_absen_model.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/app_bar_component.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';

class RekapAbsensiPage extends StatefulWidget{
  const RekapAbsensiPage({super.key});
  static const String routeName = '/rekap/absensi';

  @override
  State<RekapAbsensiPage> createState() => _RekapAbsensiView();
}

class _RekapAbsensiView extends State<RekapAbsensiPage>{
  List<dynamic> dataAbsensi = [];

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var data = await GetDataAbsenModal.getData();
    setState(() {
      dataAbsensi = data['absen']['data'];
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Center(
            child: Column(
              children: [
                DataTableAbsenComponent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class DataTableAbsenComponent extends StatelessWidget {
  DataTableAbsenComponent({super.key});
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context){
    return FutureBuilder(future: GetDataAbsenModal.getData(), builder: (context, snapshoot){
      if(snapshoot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator());
      }else if(snapshoot.hasError){
        return Text("Error: ${snapshoot.error}");
      }else{
        List<DataRow> dataRow = (snapshoot.data['absen']['data'] as List).asMap().entries.map((entry) {
          int index = entry.key + 1;
          var data = entry.value;

          return DataRow(cells: <DataCell>[
            DataCell(Text(index.toString())),
            DataCell(Text(data['user']['name'])),
            DataCell(Text(capitalizeFirstLetter(data['status']))),
            DataCell(Text(formatDate(data['created_at']))),
          ]);
        }).toList();

        return DataTable(columns: const <DataColumn>[
          DataColumn(label: Expanded(child: Text("#", style: TextStyle(fontWeight: FontWeight.bold),))),
          DataColumn(label: Expanded(child: Text("Nama", style: TextStyle(fontWeight: FontWeight.bold),))),
          DataColumn(label: Expanded(child: Text("Tipe", style: TextStyle(fontWeight: FontWeight.bold),))),
          DataColumn(label: Expanded(child: Text("Tanggal", style: TextStyle(fontWeight: FontWeight.bold),))),
        ], rows: dataRow
        );
      }
    });
  }
}

String capitalizeFirstLetter(String input) {
  switch (input) {
    case '1':
      return 'Hadir';
    case '2':
      return 'Telat';
    case '3':
      return 'Alpha';
    case '4':
      return 'WFH';
    default:
      return 'Unknown';
  }
}

String formatDate(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);

  String formattedDate = DateFormat('dd MMM At HH:mm', 'id_ID').format(dateTime);

  return formattedDate;
}