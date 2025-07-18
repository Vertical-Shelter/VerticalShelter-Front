import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/genericButton.dart';

class ReloadButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const ReloadButtonWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButtonWidget(
      borderColor: ColorsConstant.redAction,
      button: Icon(Icons.refresh),
      onPressed: onPressed,
      //TODO : fix size
      height: MediaQuery.of(context).size.height * 0.0486,
      width: MediaQuery.of(context).size.width * 0.1051,
    );
  }
}
