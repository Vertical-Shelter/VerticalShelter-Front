import 'package:app/core/app_export.dart';
import 'package:app/data/models/Contest/contestApi.dart';
import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ContestController extends GetxController {
  RxList<ContestResp> contestList = <ContestResp>[].obs;
  Rxn<ContestResp> contestResp = Rxn<ContestResp>();

  @override
  void onInit() {
    super.onInit();
    listContestResp();
  }

  void listContestResp() async {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;

    contestList.value = await listContestList(account.climbingLocationId);
    contestList.refresh();
  }

  void refreshContestResp(ContestResp contestResp) {
    this.contestResp.value = contestResp;
  }
}
