import 'package:app/Vertical-Tracking/MyStats/History/historyController.dart';
import 'package:app/Vertical-Tracking/MyStats/prgoressionController.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/core/app_export.dart';

class ProgressionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressionController>(() => ProgressionController());
    Get.lazyPut<VTMyStatsController>(() => VTMyStatsController());
    Get.lazyPut<VTHistoryController>(() => VTHistoryController());
  }
}
