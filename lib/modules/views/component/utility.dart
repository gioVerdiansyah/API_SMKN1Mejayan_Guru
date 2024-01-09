import 'package:intl/intl.dart';

String formatDate(String timestamp, {String? format}) {
  DateTime dateTime = DateTime.parse(timestamp).toLocal();

  String formattedDate = DateFormat(format ?? 'dd MMM At HH:mm', 'id_ID').format(dateTime);
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
      return 'Telat';
    case '3':
      return 'Alpha';
    case '4':
      return 'WFH';
    case '5':
      return 'Pulang';
    default:
      return 'Unknown';
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