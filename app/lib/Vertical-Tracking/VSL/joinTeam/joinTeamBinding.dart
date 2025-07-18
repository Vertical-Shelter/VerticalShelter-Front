import 'package:app/Vertical-Tracking/VSL/joinTeam/joinTeamController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class JoinTeamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinTeamcontroller>(() => JoinTeamcontroller());
  }
}