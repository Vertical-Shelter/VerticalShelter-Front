// Add linesFeed so text can feet in a column.
String? autoLineFeed(String? s, int maxLen) {
  if (s == null) return null;
  String str = s;
  int len = str.length;
  int lastBlank = maxLen;
  int start = 0;
  int end = maxLen;
  while (true) {
    if (start + maxLen > len) return str;
    for (int i = start; i < end; i++) {
      if (str[i] == ' ') lastBlank = i;
    }
    str =
        str.substring(0, lastBlank) + '\n' + str.substring(lastBlank + 1, len);
    start = lastBlank + 1;
    end = lastBlank + 1 + maxLen;
  }
}
