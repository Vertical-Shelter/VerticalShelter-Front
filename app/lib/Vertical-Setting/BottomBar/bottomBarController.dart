import 'package:app/Vertical-Setting/GymPlannification/gymPlannificationScreen.dart';
import 'package:app/Vertical-Setting/contest/contestScreen.dart';

import 'package:app/Vertical-Setting/home/homeScreen.dart';

import 'package:app/core/app_export.dart';

class VSBottomBarController extends GetxController {
  RxInt currentIndex = 1.obs;
  List pages = [
    Get.put(GymPlannificationScreen()),
    Get.put(VVSHomeScreen()),
    Get.put(ContestManagementScreen()),
  ];

  @override
  void onInit() async {
    super.onInit();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
