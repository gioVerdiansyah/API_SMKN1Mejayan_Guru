import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class GetDataAbsenModal {
  static Future getData(Uri? isAbsenPulang) async {
    try{
      final Uri url = isAbsenPulang ?? ApiRoutes.getDataAbsenRoute;
      print(isAbsenPulang);
      var response = await http.get(
        url,
        headers: {
          'x-api-key': ApiRoutes.API_KEY
        }
      );

      var data = json.decode(response.body);
      print(data);
      return data;
    }catch(e){
      print(e);
      return {
        'absensi': {
          'success': false,
          'message': 'Ada kesalahan dari aplikasi'
        }
      };
    }
  }
}