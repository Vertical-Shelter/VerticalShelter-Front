import 'dart:io';

import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendAcceptedWidget extends StatefulWidget {
  final UserNewsResp userNewsResp;

  FriendAcceptedWidget(this.userNewsResp);

  @override
  _FriendAcceptedWidget createState() => _FriendAcceptedWidget();
}

class _FriendAcceptedWidget extends State<FriendAcceptedWidget> {
  late UserNewsResp userNewsResp;

  @override
  void initState() {
    userNewsResp = widget.userNewsResp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Get.to(() => ClimbingLocationScreen(
          //     climbingLocationResp: ClimbingLocationResp(
          //         id: userNewsResp.friendId!.id,
          //         name: userNewsResp.friendId!.name,
          //         city: userNewsResp.friendId!.city,
          //         image: userNewsResp.friendId!.image)));
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                  child: CircleAvatar(
                      radius: 15,
                      backgroundColor: ColorsConstant.white,
                      // color: ColorsConstant.orangeText,
                      child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        imageUrl: userNewsResp.friendId!.image ?? '',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ))),
              const SizedBox(width: 10),
              Text(
                '${userNewsResp.friendId!.username}',
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(width: 10),
              Icon(Icons.check,
                  color: Theme.of(context).colorScheme.onSurface, size: 20),
              Text(
                AppLocalizations.of(Get.context!)!.amis,
              )
            ]));
  }
}
