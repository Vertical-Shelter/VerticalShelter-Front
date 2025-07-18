import 'package:app/Vertical-Tracking/CreateBlocSprayWall/CreateBlocController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class CreateblocBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateBlocController>(() => CreateBlocController());
  }
}