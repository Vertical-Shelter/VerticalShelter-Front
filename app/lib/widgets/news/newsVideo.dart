import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';

class NewsVideo extends StatelessWidget {
  final UserNewsResp userNewsResp;

  const NewsVideo(this.userNewsResp, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.toNamed(AppRoutesVS.WallScreenRoute, parameters: {
              'wallId': userNewsResp.args!['wall_id'],
              'SecteurId': userNewsResp.args!['secteur_id'],
              'climbingLocationId': userNewsResp.args!['climbingLocation_id'],
            }),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImage(
              image: userNewsResp.friendId!.image,
            ),
            const SizedBox(width: 10),
            Text(
              "${userNewsResp.friendId!.username} ${AppLocalizations.of(context)!.a_ajouter_une_video}",
              textAlign: TextAlign.left,
            ),
          ],
        ));
  }
}
