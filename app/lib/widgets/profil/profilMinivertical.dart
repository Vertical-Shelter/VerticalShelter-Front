import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/profil/profilImage.dart';

import 'package:app/core/app_export.dart';

class ProfileMiniVertical extends StatefulWidget {
  final String id;
  final String? name;
  final String? image;
  final Widget? trailing;
  final BaniereResp? baniereImage;
  final void Function()? onTap;
  final void Function(String id)? acceptFriend;
  final void Function(String id)? refuseFriend;
  final void Function(String id)? cancelFriend;
  final void Function(String id)? addFriend;

  FriendStatus? status;
  final bool showFriendButton;

  ProfileMiniVertical(
      {Key? key,
      required this.id,
      required this.name,
      required this.image,
      this.showFriendButton = false,
      this.status,
      this.acceptFriend,
      this.refuseFriend,
      this.cancelFriend,
      this.addFriend,
      this.baniereImage,
      this.onTap,
      this.trailing})
      : super(key: key);

  @override
  _ProfileMiniVerticalState createState() => _ProfileMiniVerticalState();
}

class _ProfileMiniVerticalState extends State<ProfileMiniVertical> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        profileImage(
          image: widget.image,
          baniereImage: widget.baniereImage,
        ),
        Flexible(
            child: Padding(
                padding: getPadding(left: 15, right: 15),
                child: Text(
                    widget.name ??
                        AppLocalizations.of(context)!
                            .cet_utilisateur_na_pas_de_nom,
                    style: Theme.of(context).textTheme.bodyMedium!))),
        widget.showFriendButton && widget.status != null
            ? Spacer()
            : Container(),
        widget.showFriendButton && widget.status != null
            ? widget.status == FriendStatus.NOT_FRIEND
                ? statusNoFriend(context)
                : widget.status == FriendStatus.PENDING
                    ? statusPending(context)
                    : widget.status == FriendStatus.REQUESTED
                        ? statusRequested(context)
                        : statusFriend(context)
            : Container(),
      ],
    );
  }

  Widget statusNoFriend(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.addFriend!(widget.id);
          setState(() {
            widget.status = FriendStatus.REQUESTED;
          });
        },
        child: Container(
            width: 200,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 2)),
            child: Text("${AppLocalizations.of(context)!.ajouter} +")));
  }

  Widget statusPending(BuildContext context) {
    return Row(children: [
      InkWell(
          onTap: () {
            widget.cancelFriend!(widget.id);
            setState(() {
              widget.status = FriendStatus.NOT_FRIEND;
            });
          },
          child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2)),
              child: Text(AppLocalizations.of(context)!.refuser))),
      SizedBox(width: 10),
      InkWell(
          onTap: () {
            widget.acceptFriend!(widget.id);
            setState(() {
              widget.status = FriendStatus.FRIEND;
            });
          },
          child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 2)),
              child: Text(AppLocalizations.of(context)!.accepeter)))
    ]);
  }

  Widget statusFriend(BuildContext context) {
    return Container(
        width: 200,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        child: Text(AppLocalizations.of(context)!.amis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.surface)));
  }

  Widget statusRequested(BuildContext context) {
    return Container(
        width: 200,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2)),
        child: Text(
          AppLocalizations.of(context)!.demande_envoyee,
        ));
  }
}

ProfileMiniVertical fromUserMini(BuildContext buildContext, dynamic user) {
  return ProfileMiniVertical(
      id: user.id, name: user.username, image: user.image);
}
