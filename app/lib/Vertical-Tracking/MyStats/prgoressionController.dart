
import 'package:app/Vertical-Tracking/MyStats/History/historyScreen.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/myStatsScreen.dart';
import 'package:app/core/app_export.dart';

class ProgressionController extends GetxController {
  RxInt index = 0.obs;

  List pages = [
    Get.put(VTMyStatsScreen()),
    Get.put(VTHistoryScreen()),
  ];

  void changeNavBar(int index) {
    this.index.value = index;
    this.index.refresh();
  }
}