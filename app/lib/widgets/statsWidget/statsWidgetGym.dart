import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';

class StatsWidgetGym extends StatelessWidget {
  final ClimbingLocationMinimalResp climbingLocationMinimalResp;
  final bool isActive;
  final Function() onTap;

  StatsWidgetGym({
    Key? key,
    required this.climbingLocationMinimalResp,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Opacity(
            opacity: isActive ? 1 : 0.5,
            child: Container(
                constraints: BoxConstraints(maxHeight: height * 0.10),
                padding: EdgeInsets.only(left: 8, right: 24),
                decoration: BoxDecoration(
                  //only bottom border
                  gradient: isActive
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context).colorScheme.primary,
                          ],
                          stops: [0.95, 0.95],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: ColorsConstant.white,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: climbingLocationMinimalResp.image!,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                        )),
                    const SizedBox(width: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            climbingLocationMinimalResp.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            climbingLocationMinimalResp.city,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ]),
                  ],
                ))));
  }
}
