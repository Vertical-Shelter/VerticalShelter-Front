import 'package:app/Vertical-Tracking/createWallAmbassadeur/createWallController.dart';
import 'package:app/core/app_export.dart';

class CreateWallAmbassadeurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateWallAmbassadeurController>(() => CreateWallAmbassadeurController());
  }
}
