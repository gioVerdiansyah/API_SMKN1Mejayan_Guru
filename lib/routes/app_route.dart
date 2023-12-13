import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/HomePage.dart';

import '../modules/views/login_page.dart';

class AppRoute{
  static GetStorage box = GetStorage();
  static String INITIAL = hasLogin();

  static String hasLogin(){
    var dataLogin = box.read('dataLogin');
    if(dataLogin != null){
      return homeRoute;
    }else{
      return loginRoute;
    }
  }

  // RouteName
  static const String loginRoute = LoginPage.routeName;
  static const String homeRoute = HomePage.routeName;

  static Map<String, WidgetBuilder> routes={
    homeRoute: (context) => const HomePage(),
    loginRoute: (context) => LoginPage(),
  };
}