import 'package:app/Vertical-Setting/GymNews/gymNewsController.dart';
import 'package:app/core/app_export.dart';

class ClimbingLocationNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClimbingLocationNewsController>(() => ClimbingLocationNewsController());
  }
}