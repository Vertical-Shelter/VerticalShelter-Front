import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';

class ClimbingLocationSoonSect extends StatelessWidget {
  final ClimbingLocationMinimalResp climbingLocationMinimalResp;

  const ClimbingLocationSoonSect(this.climbingLocationMinimalResp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
            child: CircleAvatar(
                radius: 15,
                backgroundColor: ColorsConstant.white,
                // color: ColorsConstant.orangeText,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: climbingLocationMinimalResp.image!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                ))),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.un_secteur_vient_de_fermer,
                textAlign: TextAlign.left,
              ),
              Row(children: [
                Text(
                  climbingLocationMinimalResp.name,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(width: 5),
                Text(
                  climbingLocationMinimalResp.city,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ])
            ]),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 5,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        )
      ],
    );
  }
}
