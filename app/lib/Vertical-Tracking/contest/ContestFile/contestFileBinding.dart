import 'package:app/Vertical-Tracking/contest/ContestFile/contestFileController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ContestFileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestFileController>(() => ContestFileController());
  }
}