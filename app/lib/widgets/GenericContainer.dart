import 'package:app/core/app_export.dart';

class GenericContainer extends StatelessWidget {
  final Widget child;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? margin;
  GenericContainer({
    required this.child,
    this.boxDecoration,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
      margin: margin,
      decoration: boxDecoration ??
          BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(180)),
      child: child,
    );
  }
}
