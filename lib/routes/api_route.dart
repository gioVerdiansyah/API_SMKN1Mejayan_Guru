import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class ApiRoutes {
  static String API_KEY = dotenv.get('API_KEY');
  static final GetStorage box = GetStorage();

  static final Uri loginRoute = Uri.parse("${dotenv.get('API_URL')}/login");
  static final String guruId = box.read('dataLogin')['login']['guru']['id'];

  static final Uri getDataAbsenRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/absensi/get");
  static final Uri getDataAbsenPulangRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/absensi/pulang");
  static final Uri getDataJurnalRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/get");
  static final Uri getDataJurnalSetujuiRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/get");
  static final Uri getDataJurnalTolakRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/get");
  static final Uri updateStatusJurnalRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/agreement");
  static final Uri updateStatusIzinRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/izin/agreement");
  static final Uri jurnalNextPrevDayRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/prev_day");
  static final Uri getDataDoesntJurnal = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/reject");
  static final Uri getDataDoesntAbsen = Uri.parse("${dotenv.get('API_URL')}/$guruId/absen/reject");
  static final Uri getDataIzinRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/izin/get");
}
