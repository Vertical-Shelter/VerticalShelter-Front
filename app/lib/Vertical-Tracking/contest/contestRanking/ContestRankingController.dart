import 'package:app/data/models/Contest/contestApi.dart';
import 'package:app/data/models/Contest/userContestResp.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ContestRankingController extends GetxController {
  RxList<UserContestResp> userContestResp = <UserContestResp>[].obs;
  RxString filter = ''.obs;
  RxInt index = 0.obs;
  RxBool loading = true.obs;

  void getRanking(String climbingLocationId, String contestId) async {
    userContestResp.value =
        await resultatScore(climbingLocationId, contestId, filter.value);
    loading.value = false;
    loading.refresh();
  }

  void ChangeColumn(int value) async {
    loading.value = true;
    index.value = value;
    index.refresh();
    if (index.value == 0) {
      filter.value = '';
    } else if (index.value == 1) {
      filter.value = 'M';
    } else if (index.value == 2) {
      filter.value = 'F';
    }
    getRanking(
        Get.parameters['climbingLocationId']!, Get.parameters['contestId']!);
  }

  @override
  void onInit() {
    getRanking(
        Get.parameters['climbingLocationId']!, Get.parameters['contestId']!);
    super.onInit();
  }
}
