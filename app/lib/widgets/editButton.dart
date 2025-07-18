import 'package:app/core/app_export.dart';
import 'package:app/widgets/genericButton.dart';

class EditButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const EditButtonWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButtonWidget(
      button: Icon(
        Icons.mode_edit,
        color: ColorsConstant.redAction,
      ),
      borderColor: ColorsConstant.redAction,
      onPressed: onPressed,
      color: ColorsConstant.white,
      height: MediaQuery.of(context).size.height * 0.0486,
      width: MediaQuery.of(context).size.width * 0.1051,
    );
  }
}
