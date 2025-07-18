import 'package:app/Vertical-Tracking/changeClimbingGym/changeClimbingLocController.dart';
import 'package:app/core/app_export.dart';

class VTChangeClimbingLocBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VTChangeClimbingLocController>(
      () => VTChangeClimbingLocController(),
    );
  }
}
