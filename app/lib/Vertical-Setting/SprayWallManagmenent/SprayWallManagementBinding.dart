import 'package:app/Vertical-Setting/SprayWallManagmenent/SprayWallManagementController.dart';
import 'package:app/core/app_export.dart';

class SprayWallManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SprayWallManagementController>(() => SprayWallManagementController());
  }
}