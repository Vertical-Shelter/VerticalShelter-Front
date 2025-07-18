import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Setting/GymPlannification/gymPlannificationController.dart';
import 'package:app/Vertical-Setting/contest/contestController.dart';
import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/utils/projectController.dart';
import 'package:app/utils/sprayWallController.dart';

class VSBottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GymPlannificationController());
    Get.put(ClimbingLocationController());
    Get.lazyPut<VSBottomBarController>(() => VSBottomBarController());
    Get.lazyPut<VSHomeController>(() => VSHomeController());
    Get.put(SprayWallController());

    Get.put(ProjetController());
    Get.lazyPut(() => ContestManagementController());
  }
}
