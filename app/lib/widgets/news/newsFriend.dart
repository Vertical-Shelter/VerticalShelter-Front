import 'dart:io';

import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsAskFriend extends StatefulWidget {
  final UserNewsResp userNewsResp;

  NewsAskFriend(this.userNewsResp);

  @override
  _NewsAskFriendState createState() => _NewsAskFriendState();
}

class _NewsAskFriendState extends State<NewsAskFriend> {
  late UserNewsResp userNewsResp;

  @override
  void initState() {
    userNewsResp = widget.userNewsResp;
    super.initState();
  }

  void acceptFriend(String id) async {
    try {
      accept_friend(id);
      Get.find<UserNewsController>().fetchUserNews();
    } on SocketException {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.pas_de_connexion_internet,
          snackPosition: SnackPosition.TOP);
    } on Exception {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.une_erreur_est_survenue,
          snackPosition: SnackPosition.TOP);
    }
  }

  void refuserFriend(String id) async {
    try {
      refuser_friend(id);
      Get.find<UserNewsController>().fetchUserNews();
    } on SocketException {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.pas_de_connexion_internet,
          snackPosition: SnackPosition.TOP);
    } on Exception {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.une_erreur_est_survenue,
          snackPosition: SnackPosition.TOP);
    }
  }

  Widget iconFriendShip(UserMinimalResp userMinimalResp, BuildContext context) {
    return Row(children: [
      InkWell(
          onTap: () => acceptFriend(userMinimalResp.id),
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.surface),
              child: Text(AppLocalizations.of(Get.context!)!.accepeter,
                  style: Theme.of(Get.context!).textTheme.bodyMedium!))),
      InkWell(
          onTap: () => refuserFriend(userMinimalResp.id),
          child: Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.secondary),
              child: Icon(Icons.close,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: width * 0.04)))
    ]);
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
              Expanded(
                child: Text(
                  '${userNewsResp.friendId!.username} ${AppLocalizations.of(context)!.vous_a_demander_en_amis}',
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(child: iconFriendShip(userNewsResp.friendId!, context))
            ]));
  }
}
