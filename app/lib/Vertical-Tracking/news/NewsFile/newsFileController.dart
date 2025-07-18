import 'dart:math';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/news/newsSalle/newsApi.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:intl/intl.dart';

class NewsDetailsController extends GetxController {
  RxList<NewsResp> newsList = <NewsResp>[].obs;
  Rx<NewsResp> newsResp = NewsResp().obs;
  RxString dayOfWeek = "".obs;
  RxString dayMonth = "".obs;
  RxString hour = "".obs;
  RxBool isLoading = true.obs;

  void onInit() {
    super.onInit();
    _getNews(Get.parameters['newsId']!);
  }

  void refreshNewsResp(NewsResp newsResp) {
    this.newsResp.value = newsResp;
    dayOfWeek.value =
        DateFormat.EEEE(AppLocalizations.of(Get.context!)!.pays_code)
            .format(newsResp.date!);
    dayMonth.value =
        DateFormat.MMMMd(AppLocalizations.of(Get.context!)!.pays_code)
            .format(newsResp.date!);
    hour.value = DateFormat.Hm(AppLocalizations.of(Get.context!)!.pays_code)
        .format(newsResp.date!);
  }

  void _getNews(String id) async {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;
    newsResp.value = await getNews(
        climbingLocationId: account.climbingLocationId, newsId: id);
    newsResp.refresh();
    dayOfWeek.value =
        DateFormat.EEEE(AppLocalizations.of(Get.context!)!.pays_code)
            .format(newsResp.value.date!);
    dayMonth.value =
        DateFormat.MMMMd(AppLocalizations.of(Get.context!)!.pays_code)
            .format(newsResp.value.date!);
    hour.value = DateFormat.Hm(AppLocalizations.of(Get.context!)!.pays_code)
        .format(newsResp.value.date!);
    isLoading.value = false;
  }

  onBackPressed() {
    Get.back();
  }
}
