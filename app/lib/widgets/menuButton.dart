import 'package:app/core/app_export.dart';
import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  final Key? key;
  final VoidCallback? onPressed;

  const MenuButtonWidget({this.key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onTap: onPressed,
    );
  }
}
