import 'package:app/Vertical-Tracking/Ranking/rankingGym/rankingGymController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Ranking/rankingApi.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingFriendController extends GetxController {
  RxList<UserMinimalResp> rankingList = <UserMinimalResp>[].obs;
  RxBool isLoading = true.obs;
  Rx<rankingClass> me = rankingClass().obs;
  int offset = 0;
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);
  @override
  void onInit() async {
    super.onInit();
    await rankingFriend();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> rankingFriend() async {
    rankingList.value = await rankingFriendsApi(offset);
    if (rankingList.isEmpty) {
      isLoading.value = false;
      isLoading.refresh();
      return;
    }
    var myRank = rankingList.firstWhere((element) =>
        element.id == Get.find<MultiAccountManagement>().actifAccount!.id);
    var indexRank = rankingList.indexOf(myRank) + 1;
    me.value = rankingClass(
        baniereResp: myRank.baniere,
        id: myRank.id,
        name: myRank.username!,
        image: myRank.image ?? "",
        score: myRank.point ?? 0,
        rank: indexRank);
    isLoading.value = false;
    isLoading.refresh();
    me.refresh();
  }
}
