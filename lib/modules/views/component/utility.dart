import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String formatDate(String timestamp, {String? format}) {
  DateTime dateTime = DateTime.parse(timestamp).toLocal();

  String formattedDate = DateFormat(format ?? 'dd MMM HH:mm', 'id_ID').format(dateTime);
  return formattedDate;
}

String getDateNow() {
  String formattedDate = DateFormat('EEEE dd MMMM yyyy', 'id_ID').format(DateTime.now());
  return formattedDate;
}

String capitalizeFirstLetter(String input) {
  switch (input) {
    case '1':
      return 'Hadir';
    case '2':
      return 'Hadir/Telat';
    case '3':
      return 'Alpha';
    case '4':
      return 'WFH';
    case '5':
      return 'WFH/Telat';
    default:
      return 'Unknown';
  }
}

String getDay() {
  var now = DateTime.now();
  var formatter = DateFormat('EEEE', 'id_ID');
  var hari = formatter.format(now);
  return hari.toLowerCase();
}

Widget checkStatus(data, childData) {
  if(childData['status'] == '2' || childData['status'] == '5') {
    String? jamDatang = childData['datang'];
    print("DATANYA: ${jamDatang}");

    String jamPerusahaan = data['dudi'][getDay()]!.split(' - ')[0];
    print("DATANYA: ${jamPerusahaan}");

    String waktuDatangEncode = DateFormat('H:m').format(DateTime.parse(jamDatang!));
    DateTime waktuDatang = DateFormat('H:m').parse(waktuDatangEncode);
    DateTime waktuPerusahaan = DateFormat.Hm().parse(jamPerusahaan);

    Duration selisihWaktu = waktuDatang.difference(waktuPerusahaan);

      return Text("${capitalizeFirstLetter(childData['status'])} ${selisihWaktu.inMinutes} mnt");
  }else{
    return Text(capitalizeFirstLetter(childData['status']));
  }
}

String truncateText(String inputText, int maxLength) {
  if (inputText.length <= maxLength) {
    return inputText;
  } else {
    return inputText.substring(0, maxLength) + '...';
  }
}


String truncateAndCapitalizeLastWord(String text, {int? maxLength}) {
  maxLength = maxLength ?? 15;
  if (text.length <= maxLength) {
    return text;
  }

  List<String> words = text.split(' ');

  if (words.last.length > 1) {
    words[words.length - 1] = words.last[0].toUpperCase();
  }

  String truncatedText = words.join(' ');

  return truncatedText;
}

String konversiTanggal(int jumlahHari) {
  DateTime tanggalSekarang = DateTime.now();

  DateTime tanggalHasil = tanggalSekarang.subtract(Duration(days: jumlahHari));

  String tanggalFormat = DateFormat('dd MMMM', 'id_ID').format(tanggalHasil);

  return tanggalFormat;
}