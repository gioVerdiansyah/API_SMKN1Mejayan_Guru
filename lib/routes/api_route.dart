import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class ApiRoutes {
  static String API_KEY = dotenv.get('API_KEY');
  static final GetStorage box = GetStorage();

  static final Uri loginRoute = Uri.parse("${dotenv.get('API_URL')}/login");
  static final String guruId = box.read('dataLogin')['guru']['id'];

  static final Uri getDataAbsenRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/absensi/get");
  static final Uri getDataJurnalRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/get");
  static final Uri cetakRekabAbsenRoute = Uri.parse("${dotenv.get('APP_URL')}/guru/$guruId/absen/print");
  static final Uri updateStatusJurnalRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/agreement");
  static final Uri updateStatusIzinRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/izin/agreement");
  static final Uri tolakPaksaIzinRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/izin/tolak-paksa");
  static final Uri getDataDoesntJurnal = Uri.parse("${dotenv.get('API_URL')}/$guruId/jurnal/reject");
  static final Uri getDataDoesntAbsen = Uri.parse("${dotenv.get('API_URL')}/$guruId/absensi/reject");
  static final Uri getDataIzinRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/izin/get");
  static final Uri editProfileRoute = Uri.parse("${dotenv.get('API_URL')}/$guruId/profile/edit");
}
