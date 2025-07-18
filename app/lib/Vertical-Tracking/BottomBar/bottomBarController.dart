import 'dart:math';

import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/Vertical-Tracking/MyStats/progressionScreen.dart';
import 'package:app/Vertical-Tracking/Ranking/RankingScreen.dart';
import 'package:app/Vertical-Tracking/Gyms/gymsScreen.dart';
import 'package:app/Vertical-Tracking/MyStats/History/historyScreen.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/myStatsScreen.dart';
import 'package:app/Vertical-Tracking/Social/SocialController.dart';
import 'package:app/Vertical-Tracking/Social/SocialScreen.dart';
import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalleController.dart';
import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/Vertical-Tracking/profil/profil_screen.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/FCMManager/apiFCM.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:app/utils/VSLController.dart';
import 'package:app/widgets/newsPopup.dart';

class VTBottomBarController extends GetxController {
  RxInt currentIndex = 2.obs;
  RxBool has_news_notif = false.obs;

  Rxn<UserNewsResp> newsToShow = Rxn<UserNewsResp>();
  List pages = [
    Get.put(RankingScreen()),
    Get.put(ProgressionScreen()),
    Get.put(VTGymScreen()),
    Get.put(SocialScreen()),
    Get.put(VTProfilScreen()),
  ];

  @override
  void onReady() async {
    super.onReady();
    bool hasFCM = Get.find<PrefUtils>().hasMembership();

    if (hasFCM == false) {
      sendFCMToServer();
    }
    NewsListSalleController globalNewsController =
        Get.find<NewsListSalleController>();
    VTProfilController profilController = Get.find<VTProfilController>();
    UserNewsController userNewsController = Get.find<UserNewsController>();
    VTGymController gymController = Get.find<VTGymController>();

    ever(profilController.userResp, (UserResp? userResp) {
      if (userResp != null) {
        DateTime? lastUpdatedNewsUser = userResp.lastDateNews;
        UserNewsResp? news = userNewsController.userNewsList.firstOrNull;
        if (news != null && lastUpdatedNewsUser != null) {
          DateTime latestNewsUser = news.date!;
          gymController.hasNotif.value =
              lastUpdatedNewsUser.isBefore(latestNewsUser);
          gymController.hasNotif.refresh();
          if ((news.climbingLocation_type == 'NEWS' ||
                  news.climbingLocation_type == 'CONTEST') &&
              newsToShow.value == null &&
              lastUpdatedNewsUser.isBefore(latestNewsUser)) {
            newsToShow.value = news;
          }
        }
      }
    });
    ever(userNewsController.userNewsList, (List<UserNewsResp> list) {
      if (profilController.userResp.value != null) {
        for (var e in list) {
          DateTime lastUpdatedNewsUser =
              profilController.userResp.value!.lastDateNews!;
          DateTime latestNewsUser = e.date!;
          if (newsToShow.value == null) {
            bool isBefore = lastUpdatedNewsUser.isBefore(latestNewsUser);
            gymController.hasNotif.value =
                lastUpdatedNewsUser.isBefore(latestNewsUser);
            gymController.hasNotif.refresh();
            if ((e.climbingLocation_type == 'NEWS' ||
                    e.climbingLocation_type == 'CONTEST') &&
                isBefore) {
              newsToShow.value = e;
            }
          }
        }
      }
    });
    // ever(globalNewsController.newsList, (List<NewsResp> list) {
    //   if (profilController.userResp.value != null) {
    //     for (var e in list) {
    //       DateTime lastUpdatedNewsUser =
    //             profilController.userResp.value!.lastDateNews!;
    //         DateTime latestNewsUser = e.date!;
    //       if(lastUpdatedNewsUser.isBefore(latestNewsUser)){
    //         has_notif.value = true;
    //         showDialog(context: Get.context!, builder: (BuildContext context) {
    //           return UnreadNewsPopup(newsResp: e);
    //         });
    //         has_notif.refresh();
    //       };

    //     }
    //   }
    // });
    ever(newsToShow, (UserNewsResp? popup) {
      if (popup != null) {
        showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return UnreadNewsPopup(userNewsResp: popup);
            }).then((value) => newsToShow.value = null);
      }
    });
  }

  void changeIndex(int index) {
    currentIndex.value = index;

    SocialController socialController = Get.find<SocialController>();
    VTProfilController profilController = Get.find<VTProfilController>();

    if (index == 3 && socialController.isInit.value == false) {
      socialController.initController();
    }
    if (index == 4 && profilController.isInit.value == false) {
      profilController.get_userprofile();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
