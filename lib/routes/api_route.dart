import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  static String API_KEY = dotenv.get('API_KEY');

  static final Uri loginRoute = Uri.parse("${dotenv.get('API_URL')}/login");
  static final Uri getDataAbsenRoute = Uri.parse("${dotenv.get('API_URL')}/absensi/get");
  static final Uri getDataAbsenPulangRoute = Uri.parse("${dotenv.get('API_URL')}/absensi/pulang");
}