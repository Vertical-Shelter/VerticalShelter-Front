import 'package:app/Vertical-Tracking/news/newsList/newsListVS/newsListVSController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/contest/contestCard.dart';
import 'package:app/widgets/newsCards.dart';

class NewsListVSScreen extends GetWidget<NewsListVSController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
            () => ListView.separated(
              padding: EdgeInsets.all(20.0),
              shrinkWrap: true,
              itemCount: controller.newsList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return NewsCard(
                  news: controller.newsList[index],
                );
              },
            ),
          );
  }
}