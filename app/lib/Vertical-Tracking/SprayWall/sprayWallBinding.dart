import 'package:app/Vertical-Tracking/SprayWall/sprayWallController.dart';
import 'package:get/get.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:app/Vertical-Tracking/Wall/wallController.dart';

class SprayWallbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallBetaController>(() => WallBetaController());
    Get.lazyPut<SprayWallDetailController>(() => SprayWallDetailController());
    // Get.lazyPut<VTWallController>(() => VTWallController());
  }
}
