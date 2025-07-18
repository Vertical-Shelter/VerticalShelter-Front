import 'package:app/Vertical-Tracking/news/newsList/newsController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalleController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListVS/newsListVSController.dart';
import 'package:app/core/app_export.dart';
class NewsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsListController>(() => NewsListController());
    Get.put<NewsListSalleController>(NewsListSalleController());
    Get.put<NewsListVSController>(NewsListVSController());
  }
}
