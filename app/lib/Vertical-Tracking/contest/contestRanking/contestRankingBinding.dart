import 'package:app/Vertical-Tracking/contest/contestRanking/ContestRankingController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ContestRankingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestRankingController>(() => ContestRankingController());
  }
}