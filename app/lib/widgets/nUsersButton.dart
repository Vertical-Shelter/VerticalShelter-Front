import 'package:app/core/app_export.dart';
import 'package:app/widgets/GenericButton.dart';

class nUsersButton extends StatelessWidget {
  final Key? key;
  final String text;

  const nUsersButton({this.key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButtonWidget(
      borderColor: ColorsConstant.blue,
      button: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyle.rr14,
      ),
      onPressed: null,
      height: MediaQuery.of(context).size.height * 0.0486,
      width: MediaQuery.of(context).size.height * 0.0486,
    );
  }
}
