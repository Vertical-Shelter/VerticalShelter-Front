import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/profil/profilImage.dart';

import 'package:app/core/app_export.dart';

class ProfileMiniHorizontal extends StatefulWidget {
  final String id;
  final String? name;
  final String? image;
  FriendStatus? status;
  final BaniereResp? baniereImage;
  final void Function(String id)? acceptFriend;
  final void Function(String id)? refuseFriend;
  final void Function(String id)? cancelFriend;
  final void Function(String id)? addFriend;

  ProfileMiniHorizontal({
    Key? key,
    required this.id,
    required this.status,
    required this.name,
    required this.image,
    required this.acceptFriend,
    required this.refuseFriend,
    required this.cancelFriend,
    required this.addFriend,
    this.baniereImage,
  }) : super(key: key);

  @override
  _ProfileMiniHorizontalState createState() => _ProfileMiniHorizontalState();
}

class _ProfileMiniHorizontalState extends State<ProfileMiniHorizontal> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  if (widget.id !=
                      Get.find<MultiAccountManagement>().actifAccount!.id) {
                    Get.toNamed(AppRoutesVT.UserProfileScreenRoute,
                        parameters: {
                          'id': widget.id,
                          'name': widget.name!,
                          'image': widget.image!
                        });
                  }
                },
                child: profileImage(
                  image: widget.image,
                  baniereImage: widget.baniereImage,
                )),
            SizedBox(height: 20),
            Flexible(
                child: Padding(
                    padding: getPadding(left: 15, right: 15),
                    child: Text(
                        widget.name ??
                            AppLocalizations.of(context)!
                                .cet_utilisateur_na_pas_de_nom,
                        style: Theme.of(context).textTheme.bodyMedium!))),
            SizedBox(height: 20),
            widget.status == FriendStatus.NOT_FRIEND
                ? statusNoFriend(context)
                : widget.status == FriendStatus.PENDING
                    ? statusPending(context)
                    : widget.status == FriendStatus.REQUESTED
                        ? statusRequested(context)
                        : statusFriend(context)
          ],
        ));
  }

  Widget statusNoFriend(BuildContext context) {
    return ButtonWidget(
        height: 35,
        onPressed: () {
          widget.addFriend!(widget.id);
          setState(() {
            widget.status = FriendStatus.REQUESTED;
          });
        },
        child: Text("Ajouter +",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.surface)));
  }

  Widget statusPending(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ButtonWidget(
          onPressed: () {
            widget.cancelFriend!(widget.id);
            setState(() {
              widget.status = FriendStatus.NOT_FRIEND;
            });
          },
          child: Text("Refuser",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.surface))),
      ButtonWidget(
          onPressed: () {
            widget.acceptFriend!(widget.id);
            setState(() {
              widget.status = FriendStatus.FRIEND;
            });
          },
          child: Text("Accepter",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.surface)))
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
        child: Text("Amis",
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
          "Demande envoyée",
        ));
  }
}
