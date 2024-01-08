import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class GetDataAbsenModal {
  static Future getData(Uri isAbsenPulang) async {
    try{
      final Uri url = isAbsenPulang;
      print(isAbsenPulang);
      var response = await http.post(
        url,
        headers: {
          'x-api-key': ApiRoutes.API_KEY
        },
        body: json.encode({
          'user_id': GetStorage().read('dataLogin')['login']['guru']['user_id']
        })
      );

      var data = json.decode(response.body);
      print(data);
      return data;
    }catch(e){
      return {
        'absensi': {
          'success': false,
          'message': e
        }
      };
    }
  }
}