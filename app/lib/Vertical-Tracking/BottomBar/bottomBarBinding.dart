import 'package:app/Vertical-Tracking/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Tracking/Gyms/boulder/boulderController.dart';
import 'package:app/Vertical-Tracking/Ranking/RankingController.dart';
import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/Vertical-Tracking/Social/SocialController.dart';
import 'package:app/Vertical-Tracking/contest/ContestList/contestScreen.dart';
import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalleController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListVS/newsListVSController.dart';
import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:app/utils/VSLController.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/utils/projectController.dart';
import 'package:app/utils/sprayWallController.dart';

class VTBottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ClimbingLocationController());
    Get.put(ProjetController());
    Get.put(VTProfilController());
    Get.put(UserNewsController());
    Get.put(Vslcontroller());
    // Get.put(SpQuestsController());
    // Get.put(SeasonPassController());
    Get.put(ClimbingLocationController());
    Get.put(SprayWallController());
    Get.lazyPut<VTGymController>(() => VTGymController());
    Get.lazyPut(() => BoulderController());
    Get.put<RankingController>(RankingController());
    Get.put<VTBottomBarController>(VTBottomBarController());
    Get.put<NewsListSalleController>(NewsListSalleController());
    Get.put<NewsListVSController>(NewsListVSController());
    Get.put<SocialController>(SocialController());
  }
}
