import 'package:app/core/app_export.dart';
import 'package:app/data/models/news/newsSalle/newsApi.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';

class NewsListSalleController extends GetxController {
  RxList<NewsResp> newsList = <NewsResp>[].obs;

  @override
  void onInit() {
    super.onInit();
    listNesResp();
  }

  void listNesResp() async {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;
    account.climbingLocationId != ""
        ? newsList.value = await listNewsList(
            account.climbingLocationId) // await ApiClient().listNewsList();
        : newsList.value = [];

    newsList.refresh();
  }
}
