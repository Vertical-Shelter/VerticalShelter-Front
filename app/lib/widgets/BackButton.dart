import 'package:app/core/app_export.dart';
import 'package:app/widgets/buttonWidget.dart';

class BackButtonWidget extends StatelessWidget {
  final Key? key;
  final VoidCallback? onPressed;
  final Color? color;

  const BackButtonWidget({this.key, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      color: Theme.of(context).colorScheme.surface,
      onPressed: onPressed ?? () => Get.back(),
      width: 40,
      child: Icon(Icons.arrow_back,
          size: 20, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
