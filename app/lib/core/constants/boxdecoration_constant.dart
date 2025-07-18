import 'package:app/core/app_export.dart';

class BoxDecorationConstant {
  static const double borderWidth = 2;
  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(20));

  static BoxDecoration tagDecoration = BoxDecoration(
    color: ColorsConstant.lightGreyBG,
    borderRadius: borderRadius,
    border: Border.all(
        color: ColorsConstant.blue,
        width: borderWidth,
        strokeAlign: BorderSide.strokeAlignInside),
  );

  static BoxDecoration buttonDecorationEmpty = BoxDecoration(
    color: ColorsConstant.lightGreyBG,
    borderRadius: borderRadius,
    border: Border.all(
        color: ColorsConstant.redAction,
        width: borderWidth,
        strokeAlign: BorderSide.strokeAlignInside),
  );

  static BoxDecoration buttonDecorationFull = BoxDecoration(
    color: ColorsConstant.redAction,
    borderRadius: borderRadius,
  );

  static BoxDecoration searchBarDecoration = BoxDecoration(
    color: ColorsConstant.lightGreyBG,
    borderRadius: borderRadius,
    border: Border.all(
        color: ColorsConstant.redAction,
        width: borderWidth,
        strokeAlign: BorderSide.strokeAlignInside),
  );

  static BoxDecoration dialgoWidget = BoxDecoration(
    color: ColorsConstant.lightGreyBG,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
  );
}
