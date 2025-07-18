import 'package:get/get.dart';
import 'package:app/Vertical-Tracking/Setting/setting_controller.dart';

class VTSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VTSettingController>(() => VTSettingController());
  }
}
