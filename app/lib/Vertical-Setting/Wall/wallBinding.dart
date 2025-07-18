import 'package:app/Vertical-Setting/Wall/wallController.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:get/get.dart';

class VSWallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WallBetaController());
    Get.lazyPut<VSWallController>(() => VSWallController());
  }
}
