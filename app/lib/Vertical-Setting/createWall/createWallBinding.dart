import 'package:app/Vertical-Setting/createWall/createWallController.dart';
import 'package:app/core/app_export.dart';

class VSCreateWallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VSCreateWallController>(() => VSCreateWallController());
  }
}
