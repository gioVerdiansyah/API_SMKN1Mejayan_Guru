import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class AbsenModel {
  static Future getData(Uri? isAbsenPulang) async {
    try {
      final Uri url = isAbsenPulang ?? ApiRoutes.getDataAbsenRoute;
      print(isAbsenPulang);
      var response = await http.get(url, headers: {'x-api-key': ApiRoutes.API_KEY});

      var data = json.decode(response.body);
      print(data);
      return data;
    } catch (e) {
      print(e);
      return {
        'success': false, 'message': 'Ada kesalahan dari aplikasi'
      };
    }
  }

  static Future getDataDoesntAbsen() async {
    try {
      final Uri url = ApiRoutes.getDataDoesntAbsen;
      var response = await http.get(url, headers: {'Content-Type': 'application/json', 'x-api-key': ApiRoutes.API_KEY});
      var data = json.decode(response.body);
      // print(data);
      return data;
    } catch (e) {
      return {
        'success': false, 'message': "Ada kesalahan dari aplikasi"
      };
    }
  }
}
