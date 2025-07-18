import 'package:app/core/app_export.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double borderRadius;
  final Widget child;
  final bool isSelected;
  final double? width;
  final double height;
  final Color? color;

  const ButtonWidget(
      {Key? key,
      required this.onPressed,
      this.isSelected = true,
      this.color,
      this.width,
      this.height = 40,
      this.borderRadius = 20,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(20),
            ),
        child: Center(child: child),
      ),
    );
  }
}
