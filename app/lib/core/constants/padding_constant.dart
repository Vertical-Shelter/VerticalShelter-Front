import 'package:app/core/app_export.dart';

class PaddingConstant {
  static double paddingAllRatio = 0.05;

  static EdgeInsetsGeometry mainPadding(BuildContext context) =>
      EdgeInsets.symmetric(
          vertical: context.height * paddingAllRatio,
          horizontal: context.width * paddingAllRatio);
}
