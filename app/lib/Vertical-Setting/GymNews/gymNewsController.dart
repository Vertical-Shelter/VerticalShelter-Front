import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/news/userNews/api.dart';
import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClimbingLocationNewsController extends GetxController {
  RxList<UserNewsResp> userNewsList = <UserNewsResp>[].obs;
  RxBool isLoading = true.obs;
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);
  RxMap<String, List<UserNewsResp>> dateMap =
      <String, List<UserNewsResp>>{}.obs;
  RxInt offset = 0.obs;
  @override
  void onInit() {
    fetchUserNews();
    super.onInit();
  }

  Future<void> fetchUserNews() async {
    try {
      isLoading(true);
      List<UserNewsResp> list = await listUserNews(offset: offset.value);

      if (list.isEmpty) {
        refreshController.loadNoData();
        return;
      }
      if (offset.value == 0) {
        userNewsList.clear();
      }
      userNewsList.addAll(list);

      userNewsList.refresh();
      updateDateMap();
    } finally {
      isLoading(false);
    }
  }

  void updateDateMap() {
    dateMap.clear();
    for (var e in userNewsList) {
      //check if date is today
      String date = '';
      if (e.date!.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
        date = AppLocalizations.of(Get.context!)!.aujourdhui;
      }
      //check if it is yesterday
      else if (e.date!.isAfter(DateTime.now().subtract(Duration(days: 2)))) {
        date = AppLocalizations.of(Get.context!)!.hier;
      } else {
        String dayOfWeek =
            DateFormat.EEEE(AppLocalizations.of(Get.context!)!.pays_code)
                .format(e.date!);
        String dayMonth =
            DateFormat.MMMMd(AppLocalizations.of(Get.context!)!.pays_code)
                .format(e.date!);
        date = '$dayOfWeek $dayMonth ${e.date!.year}';
      }

      if (dateMap[date] == null) {
        dateMap[date] = <UserNewsResp>[];
      }
      dateMap[date]!.add(e);
    }
    dateMap.refresh();
  }

  void updateLastDate() {
    // setLastDateNews();
  }
}
