import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/detail_jurnal.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/edit_profile_page.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/home_page.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/rekap_absensi_page.dart';

import '../modules/views/rekap_izin_page.dart';
import '../modules/views/login_page.dart';
import '../modules/views/rekap_jurnal_page.dart';

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
  static const String rekapAbsensi = RekapAbsensiPage.routeName;
  static const String rekapJurnal = RekapJurnalPage.routeName;
  static const String rekapIzin = RekapIzinPage.routeName;
  static const String editProfile = EditProfilePage.routeName;

  static Map<String, WidgetBuilder> routes={
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage(),
    rekapAbsensi: (context) => RekapAbsensiPage(),
    rekapJurnal: (context) => RekapJurnalPage(),
    rekapIzin: (context) => RekapIzinPage(),
    editProfile: (context) => EditProfilePage(),
  };
}