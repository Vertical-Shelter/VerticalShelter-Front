import 'package:pinput/pinput.dart';
import 'package:app/core/app_export.dart';

class CodeValidationWidget extends StatelessWidget {
  final TextEditingController pinController;
  final FormFieldValidator validator;
  final String? errorText;
  final Function(String) onCompleted;

  CodeValidationWidget(
      {Key? key,
      required this.validator,
      required this.pinController,
      required this.onCompleted,
      required this.errorText})
      : super(key: key);

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: ColorsConstant.greyText),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
      // Specify direction if desired
      textDirection: TextDirection.ltr,
      child: Pinput(
        autofocus: true,
        length: 6,
        controller: pinController,
        validator: validator,
        onCompleted: onCompleted,
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsConstant.greyText),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            color: ColorsConstant.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsConstant.greyText),
          ),
        ),
        errorText: errorText,
        // forceErrorState: true,
        errorPinTheme: errorText == null
            ? defaultPinTheme
            : defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
      ),
    );
  }
}
