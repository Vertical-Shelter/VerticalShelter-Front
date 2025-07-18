import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';

class ClimbingLocationCard extends StatelessWidget {
  final ClimbingLocationResp climbingLocationResp;
  final bool isActive;
  final Function() onTap;

  ClimbingLocationCard({
    Key? key,
    required this.climbingLocationResp,
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  //only bottom border
                  color: ColorsConstantDarkTheme.purple,
                  border: Border.all(
                    color: ColorsConstantDarkTheme.secondary,
                  ),
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
                          imageUrl: climbingLocationResp.image!,
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
                            climbingLocationResp.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            climbingLocationResp.city,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ]),
                  ],
                ))));
  }
}
