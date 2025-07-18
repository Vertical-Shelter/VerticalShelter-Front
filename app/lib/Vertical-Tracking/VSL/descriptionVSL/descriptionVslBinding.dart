import 'package:app/Vertical-Tracking/VSL/descriptionVSL/descriptionVSLController.dart';
import 'package:app/core/app_export.dart';

class DescriptionVslBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DescriptionVslController>(() => DescriptionVslController());
  }
}