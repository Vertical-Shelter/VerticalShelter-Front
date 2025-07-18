import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';

class GenericButtonWidget extends StatelessWidget {
  Color? color = ColorsConstant.white;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool showShadow;
  final Widget? button;
  final Color? borderColor;
  final VoidCallback? onLongPress;

  GenericButtonWidget({
    Key? key,
    this.showShadow = false,
    this.color,
    this.borderColor,
    this.onLongPress,
    this.width,
    this.height,
    required this.button,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onPressed,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 2,
                color: borderColor ?? Colors.transparent,
              ),
              color: color,
            ),
            child: Center(child: button)),
      ),
    );
  }
}
