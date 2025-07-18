import 'package:app/Vertical-Tracking/Ranking/RankingController.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingFriend/rankingFriendController.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingGym/rankingGymController.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingGlobalScreen/rankingGlobalController.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingVSL/rankingVSLController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/utils/VSLController.dart';

class RankingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Vslcontroller>(() =>Vslcontroller());// change here
    Get.lazyPut<RankingController>(() => RankingController());
    Get.lazyPut<RankingVSLController>(() => RankingVSLController());
    Get.lazyPut<RankingGymController>(() => RankingGymController());
    Get.lazyPut<RankingGlobalController>(() => RankingGlobalController());
    Get.lazyPut<RankingFriendController>(() => RankingFriendController());
  }
}