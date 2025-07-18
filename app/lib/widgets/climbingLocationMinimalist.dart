import 'package:app/Vertical-Tracking/contest/ContestList/contestController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalleController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';

class ClimbingLocationMinimalistWidget extends StatelessWidget {
  final BuildContext parentsContext;
  final ClimbingLocationResp climbingLocationMinimalResp;
  final void Function()? onPressed;
  bool isSelected;

  ClimbingLocationMinimalistWidget(
      this.parentsContext, this.climbingLocationMinimalResp,
      {super.key, this.onPressed, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
            padding: isSelected ? const EdgeInsets.all(10) : null,
            decoration: isSelected
                ? BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                  )
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                    child: CircleAvatar(
                        radius: 20,
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
                        climbingLocationMinimalResp.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        climbingLocationMinimalResp.city,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ]),
                const SizedBox(width: 10),
                climbingLocationMinimalResp.isPartnership
                    ? Icon(
                        Icons.verified,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      )
                    : Container()
              ],
            )));
  }
}
