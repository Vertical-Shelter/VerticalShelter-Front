import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Ranking/rankingApi.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/VSLController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class RankingVSLController extends GetxController {
 
  RxString currentGymId = "".obs;
  RxBool hasMembership = false.obs;

  RxBool isLoading = true.obs;

  int offset = 0;
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  final RefreshController refreshControllerRanking = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  Vslcontroller vsl = Get.find<Vslcontroller>();

  Future<void> init() async {
    
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
}
