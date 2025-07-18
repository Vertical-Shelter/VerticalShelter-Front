import 'package:app/core/app_export.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:app/widgets/MyCachedNetworkItmage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final NewsResp news;

  const NewsCard({Key? key, required this.news});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.toNamed(AppRoutesVT.newsDetailsRoute,
            parameters: {"newsId": news.id!}),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 80,
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  child: MyCachedNetworkImage(
                    width: width,
                    height: height,
                    imageUrl: news.imageUrl == null ? '' : news.imageUrl!,
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                    child: Column(children: [
                  Text(news.title!,
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(
                    height: 10,
                  ),
                ]))

                //si la date est la meme qu'aujourd'hui ecrire en cours
              ],
            )));
  }
}
