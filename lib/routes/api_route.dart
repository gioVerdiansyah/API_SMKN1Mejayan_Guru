import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/env.dart';

class ApiRoutes {
  static String API_KEY = Env.API_KEY;
  static final GetStorage box = GetStorage();

  static final Uri loginRoute = Uri.parse("${Env.API_URL}/login");
  static final String guruId = box.read('dataLogin')['guru']['id'];

  static final Uri getDataAbsenRoute = Uri.parse("${Env.API_URL}/$guruId/absensi/get");
  static final Uri getDataJurnalRoute = Uri.parse("${Env.API_URL}/$guruId/jurnal/get");
  static final Uri cetakRekabAbsenRoute = Uri.parse("${Env.APP_URL}/guru/$guruId/absen/print");
  static final Uri updateStatusJurnalRoute = Uri.parse("${Env.API_URL}/$guruId/jurnal/agreement");
  static final Uri updateStatusIzinRoute = Uri.parse("${Env.API_URL}/$guruId/izin/agreement");
  static final Uri tolakPaksaIzinRoute = Uri.parse("${Env.API_URL}/$guruId/izin/tolak-paksa");
  static final Uri getDataDoesntJurnal = Uri.parse("${Env.API_URL}/$guruId/jurnal/reject");
  static final Uri getDataDoesntAbsen = Uri.parse("${Env.API_URL}/$guruId/absensi/reject");
  static final Uri getDataIzinRoute = Uri.parse("${Env.API_URL}/$guruId/izin/get");
  static final Uri editProfileRoute = Uri.parse("${Env.API_URL}/$guruId/profile/edit");
  static final Uri getAnggotaRoute = Uri.parse("${Env.API_URL}/$guruId/anggota/get");
  static final Uri absenTroubleRoute = Uri.parse("${Env.API_URL}/$guruId/absensi/trouble");
}
