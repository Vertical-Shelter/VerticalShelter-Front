import 'package:flutter/widgets.dart';
import 'package:app/core/app_export.dart';
import 'package:app/core/constants/colorConstant.dart';

class AppTextStyle {
  static double ratio = 1;

  static TextStyle rm20 = TextStyle(
    decoration: TextDecoration.none,
    color: ColorsConstant.greyText,
    fontSize: 20 * ratio,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
  );

  static TextStyle rr14 = TextStyle(
    decoration: TextDecoration.none,
    color: ColorsConstant.greyText,
    fontSize: 14 * ratio,
    fontWeight: FontWeight.w600,
    fontFamily: 'Roboto',
  );
  static TextStyle rb30 = TextStyle(
    color: ColorsConstant.greyText,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static const TextStyle rb14 = TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
  );

  static TextStyle rmResizable(double fontSize) => TextStyle(
        decoration: TextDecoration.none,
        color: ColorsConstant.greyText,
        fontSize: fontSize *
                    ((Get.width * 100 / 390 + Get.height * 100 / 182) / 2) /
                    100 >
                fontSize
            ? fontSize
            : fontSize *
                ((Get.width * 100 / 390 + Get.height * 100 / 182) / 2) /
                100,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto',
      );

  static TextStyle rrResizable(double fontSize) => TextStyle(
        decoration: TextDecoration.none,
        color: ColorsConstant.greyText,
        fontSize: fontSize *
                    ((Get.width * 100 / 390 + Get.height * 100 / 182) / 2) /
                    100 >
                fontSize
            ? fontSize
            : fontSize *
                ((Get.width * 100 / 390 + Get.height * 100 / 182) / 2) /
                100,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      );
}
