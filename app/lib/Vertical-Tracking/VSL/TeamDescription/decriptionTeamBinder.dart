import 'package:app/Vertical-Tracking/VSL/TeamDescription/decriptionTeamController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class DescriptionTeamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DescriptionTeamcontroller>(() => DescriptionTeamcontroller());
  }
}