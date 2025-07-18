import 'package:app/Vertical-Tracking/contest/ContestList/contestController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_instance/src/bindings_interface.dart';


class ContestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestController>(() => ContestController());
  }
}
