import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  static String API_KEY = dotenv.get('API_KEY');

  static final Uri loginRoute = Uri.parse("${dotenv.get('API_URL')}/login");
  static final Uri getDataAbsenRoute = Uri.parse("${dotenv.get('API_URL')}/absensi/get");
  static final Uri getDataAbsenPulangRoute = Uri.parse("${dotenv.get('API_URL')}/absensi/pulang");
  static final Uri getDataJurnalRoute = Uri.parse("${dotenv.get('API_URL')}/jurnal/get");
  static final Uri getDataJurnalSetujuiRoute = Uri.parse("${dotenv.get('API_URL')}/jurnal/get");
  static final Uri getDataJurnalTolakRoute = Uri.parse("${dotenv.get('API_URL')}/jurnal/get");
  static final Uri updateStatusJurnalRoute = Uri.parse("${dotenv.get('API_URL')}/jurnal/agreement");
}
