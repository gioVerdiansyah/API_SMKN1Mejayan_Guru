import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/routes/api_route.dart';

class LoginModel{
  static GetStorage box = GetStorage();

  static Future sendPost(String username, String password) async{
    try {
      final Uri url = ApiRoutes.loginRoute;
      var response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiRoutes.API_KEY
          },
          body: json.encode({
            'email': username,
            'password': password
          })
      );

      var data = json.decode(response.body);
      print(data);
      return data;
    }catch(e){
      return {
        'login': {
          'success': false, 'message': e
        }
      };
    }
  }
}