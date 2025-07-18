import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Ranking/rankingApi.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class rankingClass {
  final String id;
  final String name;
  final String image;
  final double score;
  final int rank;
  final BaniereResp? baniereResp;

  rankingClass(
      {this.id = "",
      this.baniereResp,
      this.name = "",
      this.image = "",
      this.score = 0,
      this.rank = 0});
}

class RankingGymController extends GetxController {
  RxMap<String, List<UserMinimalResp>> rankingList =
      <String, List<UserMinimalResp>>{}.obs;
  RxString currentGymId = "".obs;
  RxBool hasMembership = false.obs;
  RxList<ClimbingLocationMinimalResp> gymLists =
      <ClimbingLocationMinimalResp>[].obs;
  RxBool isLoading = true.obs;
  Rx<rankingClass> me = rankingClass().obs;

  int offset = 0;
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);



  Future<void> init() async {
    gymLists.value = await getMyCloc();
    if (gymLists.isEmpty) {
      isLoading.value = false;
      return;
    }
    for (var gym in gymLists) {
      rankingList[gym.id] = [];
    }
    gymLists.refresh();
    currentGymId.value = gymLists[0].id;
    await rankingGym(gymLists[0].id);
  }

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> rankingGym(String? gym_id) async {
    gym_id ??=
        Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
    rankingList[gym_id] = await rankingClimbingLocationApi(gym_id, offset);
    if (rankingList.isEmpty) {
      me.refresh();
      isLoading.value = false;
      isLoading.refresh();
      return;
    }
    var myRank = rankingList[gym_id]!.firstWhere((element) =>
        element.id == Get.find<MultiAccountManagement>().actifAccount!.id);
    var indexRank = rankingList[gym_id]!.indexOf(myRank) + 1;
    me.value = rankingClass(
        id: myRank.id,
        baniereResp: myRank.baniere,
        name: myRank.username!,
        image: myRank.image ?? "",
        score: myRank.point ?? 0,
        rank: indexRank);
    me.refresh();
    isLoading.value = false;
    isLoading.refresh();
  }

  void changeCurrentGym(String currentGym) {
    isLoading.value = true;
    isLoading.refresh();
    currentGymId.value = currentGym;
    currentGymId.refresh();
    if (rankingList.containsKey(currentGym) &&
        rankingList[currentGym]!.isNotEmpty) {
      isLoading.value = false;
      isLoading.refresh();
      return;
    } else {
      rankingGym(currentGym);
    }
    isLoading.value = false;
    isLoading.refresh();
  }
}
