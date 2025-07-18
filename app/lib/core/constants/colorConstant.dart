import 'package:flutter/material.dart';

class ColorText {
  String text;
  Color color;
  ColorText({required this.text, required this.color});
}
 
class ColorsConstantDarkTheme {
  static Color Natural_Button = fromHex('2F2F2F');
  static Color primary = fromHex('D1FF97');
  static Color secondary = fromHex('FF0046');
  static Color background = fromHex('1E1E1E');
  static Color neutral_black = fromHex('252525');
  static Color neutral_white = fromHex('F3F2F7');
  static Color neutral_tab = fromHex('303030');
  static Color neutral_grey = fromHex('8C8C8C');
  static Color tertiary = fromHex('7488FF');
  static Color lightPurple = fromHex('210124');
  static Color purple = fromHex('120114');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class ColorsConstantLightTheme {
  static Color Natural_Button = fromHex('2F2F2F');
  static Color secondary = fromHex('D1FF97');
  static Color primary = fromHex('FF5757');
  static Color neutral_white = fromHex('F1F1EF');
  static Color neutral_black = fromHex('252525');
  static Color background = fromHex('FFFFFF');
  static Color neutral_tab = fromHex('303030');
  static Color neutral_grey = fromHex('8C8C8C');
  static Color tertiary = fromHex('7488FF');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class ColorsConstant {
  static Color greyText = fromHex('333333');
  static Color orangeText = fromHex('F2CF1D');
  static Color redAction = fromHex('F2622E');
  static Color white = fromHex('ffffff');
  static Color blue = fromHex('517EF5');

  //New colors

  //for text fields
  static Color lightGreyText = fromHex('AFAFAF');
  static Color lightGreyBG = fromHex('F7F8F9');
  static Color lightGreyStroke = fromHex('E8ECF4');

  static Color fromHex(String hexString) {
    if (hexString.length > 6) hexString = hexString.substring(0, 6);
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static const List<Color> defaultColorList = [
    // 17 different colors
    Color(0xFFF2CF1D),
    Color(0xFFF2622E),
    Color(0xFF7488FF),
    Color(0xFF2ECC71),
    Color(0xFFE67E22),
    Color(0xFF3498DB),
    Color.fromARGB(255, 231, 60, 60),
    Color(0xFF9B59B6),
    Color(0xFF1ABC9C),
    Color.fromARGB(255, 120, 200, 206),
    Color.fromARGB(255, 192, 224, 27),
    Color(0xFF34495E),
    Color.fromARGB(255, 20, 130, 66),
    Color(0xFF2980B9),
    Color(0xFF8E44AD),
    Color(0xFF16A085),
    Color(0xFF2C3E50),
  ];
}
