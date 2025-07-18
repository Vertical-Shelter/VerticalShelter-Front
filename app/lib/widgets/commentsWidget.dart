import 'dart:math';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Comments/commentsResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/profil/profilImage.dart';

class CommentsWidget extends StatelessWidget {
  final CommentsResp commentsResp;
  late bool isDeletable;
  void Function() ondelete; // function
  void Function()? onreply; // function
  late String username;
  CommentsWidget(
      {Key? key,
      required this.commentsResp,
      required this.ondelete,
      this.onreply})
      : super(key: key) {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;
    if (commentsResp.user!.id == account.id) {
      isDeletable = true;
    } else {
      if (account.isGym == true) {
        isDeletable = true;
      } else {
        isDeletable = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () => Get.toNamed(AppRoutesVT.UserProfileScreenRoute,
              parameters: {"userId": commentsResp.user!.id!}),
          child: profileImage(
            image: commentsResp.user!.image,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              commentsResp.user!.username!,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            SizedBox(height: 5),
            Text(
              commentsResp.message!,
              maxLines: 12,
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ],
        )),
        // Reply

        SizedBox(width: 10),
        //button delete
        if (isDeletable)
          InkWell(
              onTap: () => ondelete(),
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ))
      ],
    );
  }
}
