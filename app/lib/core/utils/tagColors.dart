import 'package:app/core/app_export.dart';

Color tagColor(String colorName) {
  try {
    return ColorsConstant.fromHex(colorName);
  } catch (e) {
    return ColorsConstant.white;
  }
}

String tagText(String colorName) {
  try {
    ColorsConstant.fromHex(colorName);
    return "      ";
  } catch (e) {
    return colorName;
  }
}
