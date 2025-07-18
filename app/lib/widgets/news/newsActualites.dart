import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';

class NewsActualites extends StatelessWidget {
  final UserNewsResp userNewsResp;

  const NewsActualites(this.userNewsResp, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.toNamed(AppRoutesVT.NewsRoute),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
                child: CircleAvatar(
                    radius: 15,
                    backgroundColor: ColorsConstant.white,
                    // color: ColorsConstant.orangeText,
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: userNewsResp.climbingLocation!.image!,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                    ))),
            const SizedBox(width: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.nouvelle_actualite} : ${userNewsResp.news_id!.title!}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  Row(children: [
                    Text(
                      userNewsResp.climbingLocation!.name,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(width: 5),
                    Text(
                      userNewsResp.climbingLocation!.city,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ])
                ]),
          ],
        ));
  }
}
