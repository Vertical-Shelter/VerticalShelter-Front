import 'package:get/get.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:app/Vertical-Tracking/Wall/wallController.dart';

class VTWallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallBetaController>(() => WallBetaController());
    Get.lazyPut<VTWallController>(() => VTWallController());
  }
}
