String truncateAndCapitalizeLastWord(String text, int maxLength) {
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