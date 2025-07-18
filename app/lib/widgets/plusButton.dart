import 'package:app/core/app_export.dart';
import 'package:app/widgets/genericButton.dart';

class PlusButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const PlusButtonWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButtonWidget(
      borderColor: ColorsConstant.redAction,
      color: ColorsConstant.white,
      button: Icon(Icons.add, color: ColorsConstant.redAction),
      onPressed: onPressed,
      //TODO : fix size
      height: MediaQuery.of(context).size.height * 0.0486,
      width: MediaQuery.of(context).size.width * 0.1051,
    );
  }
}
