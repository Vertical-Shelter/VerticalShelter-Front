import 'package:app/core/app_export.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:app/data/models/news/newsSalle/newsVSAPI.dart';

class NewsListVSController extends GetxController {
  RxList<NewsResp> newsList = <NewsResp>[].obs;
  

  @override
  void onInit() {
    super.onInit();
    listNesResp();
  }

  void listNesResp() async {
    newsList.value = await listNewsVSList(); // await ApiClient().listNewsList();
    newsList.refresh();
  }
}
