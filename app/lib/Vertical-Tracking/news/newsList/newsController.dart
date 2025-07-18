import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalle.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListVS/newsListVS.dart';
import 'package:app/core/app_export.dart';


class NewsListController extends GetxController {
  RxInt index = 0.obs;
  RxBool isFocusing = false.obs;
  List<Widget> pages = [
    NewsListSalleScreen(),
    NewsListVSScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void changeColumn(int value) async {
    index.value = value;
    index.refresh();
  }

  
}
