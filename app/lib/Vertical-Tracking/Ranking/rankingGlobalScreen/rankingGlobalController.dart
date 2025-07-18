import 'package:app/Vertical-Tracking/Ranking/rankingGym/rankingGymController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Ranking/rankingApi.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingGlobalController extends GetxController {
  RxList<UserMinimalResp> rankingList = <UserMinimalResp>[].obs;
  Rx<rankingClass> me = rankingClass().obs;
  RxBool isLoading = true.obs;
  int offset = 0;
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  @override
  void onInit() async {
    await rankingGlobal();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void refreshPaiementStatus() async {
  //   hasMembership.value = Get.find<PrefUtils>().hasMembership();
  //   hasMembership.refresh();
  // }
  Future<void> refresh() async {
    rankingList.clear();
    offset = 0;
    await rankingGlobal();
    refreshController.refreshCompleted();
  }

  Future<void> rankingGlobal() async {
    var date = DateTime.now();
    rankingList.addAll(await rankingGlobalApi(offset));
    print(date.difference(DateTime.now()).inMilliseconds);

    var myRank = rankingList.firstWhereOrNull((element) =>
        element.id == Get.find<MultiAccountManagement>().actifAccount!.id);
    var indexRank = rankingList.indexOf(myRank) + 1;
    me.value = myRank == null
        ? rankingClass(
            id: Get.find<MultiAccountManagement>().actifAccount!.id,
            name: Get.find<MultiAccountManagement>().actifAccount!.name,
            image: Get.find<MultiAccountManagement>().actifAccount!.picture,
            score: 0,
            rank: 0)
        : rankingClass(
            baniereResp: myRank.baniere,
            id: myRank.id,
            name: myRank.username!,
            image: myRank.image ?? "",
            score: myRank.point ?? 0,
            rank: indexRank);
    me.refresh();
    isLoading.value = false;
    isLoading.refresh();
    print(date.difference(DateTime.now()).inMilliseconds);
  }
}
