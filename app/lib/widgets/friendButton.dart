import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/widgets/ConfirmDialog.dart';
import 'package:app/widgets/genericButton.dart';

class FriendButtonController {
  final Rx<FriendStatus> status;
  final String userId;

  FriendButtonController({required this.status, required this.userId});

  OnTapFriendButton(BuildContext context, bool accept) async {
    // if (friend_status.value == 'unknow') {
    //   FriendrequestResp resp = await friendrequest_create(userResp!.id!);
    //   friend_status.value = 'pending_rec';
    // } else if (friend_status.value == 'pending_rec') {
    //   showDialog(
    //       context: context,
    //       builder: (context) => ConfirmDialog(
    //           title: 'Cancel friend request ?',
    //           onConfirm: (context) async {
    //             friendrequest_delete(false, userResp!.id!);
    //           }));
    // } else if (friend_status.value == 'pending_send') {
    //   await friendrequest_delete(accept, userResp!.id!);
    //   friend_status.value = accept ? 'friend' : 'unknow';
    // } else {}
    // return;
  }

  onAddFriendPressed() async {
    await add_friend(userId);
    status.value = FriendStatus.REQUESTED;
  }

  onCancelFriendRequest(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
            title: AppLocalizations.of(context)!.annuler_la_demande_damis,
            onConfirm: (context) async {
              cancel_friend(userId);
              status.value = FriendStatus.NOT_FRIEND;
              Navigator.of(context).pop();
            }));
  }

  onAcceptFriendRequest() async {
    await accept_friend(userId);
    status.value = FriendStatus.FRIEND;
  }

  onRefuseFriendRequest() async {
    await refuser_friend(userId);
    status.value = FriendStatus.NOT_FRIEND;
  }

  onDeleteFriend(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
            title: AppLocalizations.of(context)!.supprimer_cet_amis,
            onConfirm: (context) async {
              delete_friend(userId);
              status.value = FriendStatus.NOT_FRIEND;
              Navigator.of(context).pop();
            }));
  }
}

class FriendButtonWidget extends StatelessWidget {
  final Key? key;
  final FriendButtonController controller;

  FriendButtonWidget({
    this.key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.status.value == 'unknow')
        return GenericButtonWidget(
          button: Icon(
            Icons.person_add,
            color: Colors.black,
          ),
          onPressed: controller.onAddFriendPressed,
          height: MediaQuery.of(context).size.height * 0.0486,
          width: MediaQuery.of(context).size.width * 0.1051,
        );
      else if (controller.status.value == 'pending_rec')
        return GenericButtonWidget(
          button: Icon(Icons.access_alarms),
          onPressed: () => controller.onCancelFriendRequest(context),
          height: MediaQuery.of(context).size.height * 0.0486,
          width: MediaQuery.of(context).size.width * 0.1051,
        );
      else if (controller.status.value == 'friend')
        return GenericButtonWidget(
          button: Icon(Icons.abc),
          onPressed: () => controller.onDeleteFriend(context),
          height: MediaQuery.of(context).size.height * 0.0486,
          width: MediaQuery.of(context).size.width * 0.1051,
        );
      else
        return Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.accepter_la} \n ${AppLocalizations.of(context)!.demande_damis}  ',
              style: AppTextStyle.rr14,
              textAlign: TextAlign.center,
            ),
            GenericButtonWidget(
              color: Colors.green,
              button: Icon(
                Icons.done,
                color: Colors.black,
              ),
              onPressed: controller.onAcceptFriendRequest,
              height: MediaQuery.of(context).size.height * 0.0486,
              width: MediaQuery.of(context).size.width * 0.1051,
            ),
            SizedBox(
              width: 7,
            ),
            GenericButtonWidget(
              color: Colors.red,
              button: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: controller.onRefuseFriendRequest,
              height: MediaQuery.of(context).size.height * 0.0486,
              width: MediaQuery.of(context).size.width * 0.1051,
            ),
          ],
        );
    });
  }
}
