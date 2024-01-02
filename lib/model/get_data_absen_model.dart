import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class GetDataAbsenModal {
  static Future getData() async {
    try{
      final Uri url = ApiRoutes.getDataAbsenRoute;
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
      return {
        'absensi': {
          'success': false,
          'message': e
        }
      };
    }
  }
}