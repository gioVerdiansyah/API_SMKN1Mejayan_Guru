import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class JurnalModel {
  static final GetStorage box = GetStorage();
  static Future getData(Uri? changeUrl) async {
    try {
      final Uri url = changeUrl ?? Uri.parse("${ApiRoutes.getDataJurnalRoute}");
      var response = await http.get(url, headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY});

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {
        'jurnal': {'success': false, 'message': "Ada kesalahan dari aplikasi"}
      };
    }
  }

  static Future agreementJurnal(String jurnalId, String? keterangan, int status) async {
    try {
      final Uri url = ApiRoutes.updateStatusJurnalRoute;
      var response = await http.put(url,
          headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY},
          body: json.encode({'jurnal_id': jurnalId, 'keterangan': keterangan, 'status': status}));

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      return {'success': false, 'message': "Ada kesalahan aplikasi!"};
    }
  }

  static Future getDataDoesntJurnal(String? namaKelompok) async {
    try {
      final Uri url = Uri.parse("${ApiRoutes.getDataDoesntJurnal}/$namaKelompok");
      var response = await http.get(url, headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY});

      var data = json.decode(response.body);
      print("BELUMM ${data}");
      return data;
    } catch (e) {
      return {'success': false, 'messgae': "Ada kesalahaan aplikasi"};
    }
  }
}
