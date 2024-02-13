import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class AbsenModel {
  static Future getData({Uri? changeUrl}) async {
    try {
      final Uri url = changeUrl ?? ApiRoutes.getDataAbsenRoute;
      print(changeUrl);
      var response = await http.get(url, headers: {'x-api-key': ApiRoutes.API_KEY});

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return {'success': false, 'message': 'Ada kesalahan dari aplikasi'};
    }
  }

  static Future getDataDoesntAbsen(String? namaKelompok) async {
    try {
      final Uri url = Uri.parse("${ApiRoutes.getDataDoesntAbsen}/$namaKelompok");
      var response = await http.get(url, headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY});
      var data = json.decode(response.body);
      // print(data);
      return data;
    } catch (e) {
      return {'success': false, 'message': "Ada kesalahan dari aplikasi"};
    }
  }

  static Future getAnggota() async {
    try {
      final Uri url = ApiRoutes.getAnggotaRoute;
      var response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY},
      );

      var data = json.decode(response.body);
      print("DATA ANGGOTA: ${data}");
      return data;
    } catch (e) {
      return {'success': false, 'message': "Ada kesalahan Aplikasi"};
    }
  }

  static Future absenTrouble(String namaSiswa, String tipeKehadiran) async {
    try {
      final Uri url = ApiRoutes.absenTroubleRoute;
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY},
          body: json.encode({'nama_siswa': namaSiswa, 'tipe_kehadiran': tipeKehadiran}));

      var data = json.decode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'message': "Ada kesalahan Aplikasi"};
    }
  }
}
