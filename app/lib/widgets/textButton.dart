import 'package:app/core/app_export.dart';
import 'package:app/widgets/genericButton.dart';

// ignore: must_be_immutable
class TextButtonWidget extends StatelessWidget {
  final Key? key;
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final TextStyle? appTextStyle;
  final double heightCoeff;
  final double widthCoeff;

  TextButtonWidget(
      {this.key,
      this.onPressed,
      this.color,
      this.appTextStyle,
      required this.text,
      this.heightCoeff = 0.08,
      this.widthCoeff = 0.9})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButtonWidget(
        button: Text(
          text,
          textAlign: TextAlign.center,
          style: appTextStyle ?? AppTextStyle.rm20,
        ),
        borderColor: ColorsConstant.redAction,
        color: color,
        onPressed: onPressed,
        height: MediaQuery.of(context).size.height * heightCoeff,
        width: MediaQuery.of(context).size.width * widthCoeff);
  }
}
