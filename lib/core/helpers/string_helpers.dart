extension StringExtension on String {
  String capitalizeFirstLetter(String s) =>
      (s.isNotEmpty) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

String formatTitleShort(id, type) {
  return id != null ? "$type - $id" : "$type";
}

String formatStringShort(String text, int maxWordLength) {
  return text.length >= maxWordLength
      ? text.substring(0, maxWordLength) + "..."
      : text;
}
