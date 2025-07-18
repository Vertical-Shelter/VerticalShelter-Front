import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/video/videoResp.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/widgets/statsWidget/statsWidgetGym.dart';
import 'package:app/Vertical-Tracking/UserProfile/userProfile_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:app/widgets/walls/wallHistoryWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';

class VTUserProfileScreen extends GetWidget<VTUserProfilController> {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(children: [
            BackButtonWidget(
              onPressed: controller.onTapBackButton,
            ),
            Spacer(),
            Obx(() => controller.is_loading.value == true
                ? Container()
                : iconFriendShip(context, controller.userResp.value!))
          ]),
        ),
        body: Obx(() => controller.is_loading.value == true
            ? Center(child: CircularProgressIndicator())
            : body(context)));
  }

  Widget iconFriendShip(BuildContext context, UserResp userMinimalResp) {
    if (userMinimalResp.friendStatus == FriendStatus.PENDING) {
      return Row(children: [
        InkWell(
            onTap: () => controller.acceptFriend(userMinimalResp.id!),
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(Get.context!).colorScheme.surface),
                child: Text(AppLocalizations.of(context)!.accepeter,
                    style: Theme.of(Get.context!).textTheme.bodyMedium!))),
        InkWell(
            onTap: () => controller.cancelFriend(userMinimalResp.id!),
            child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(Get.context!).colorScheme.primary),
                child: Icon(Icons.close,
                    color: ThemeData().colorScheme.onSurface,
                    size: width * 0.04)))
      ]);
    }
    if (userMinimalResp.friendStatus == FriendStatus.NOT_FRIEND) {
      return InkWell(
          onTap: () => controller.addFriend(userMinimalResp.id!),
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(Get.context!).colorScheme.onTertiary),
              child: Row(children: [
                Icon(Icons.add, size: width * 0.07),
                Text(AppLocalizations.of(context)!.ajouter,
                    style: Theme.of(Get.context!).textTheme.bodyMedium!)
              ])));
    }
    if (userMinimalResp.friendStatus == FriendStatus.REQUESTED) {
      return InkWell(
          onTap: () => controller.cancelFriend(userMinimalResp.id!),
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(Get.context!).colorScheme.secondary),
              child: Text(AppLocalizations.of(context)!.annuler,
                  style: Theme.of(Get.context!).textTheme.bodyMedium!)));
    }

    if (userMinimalResp.friendStatus == FriendStatus.FRIEND) {
      return InkWell(
          onTap: () => controller.deleteFriend(context, userMinimalResp.id!),
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(Get.context!).colorScheme.surface),
              child: Text(AppLocalizations.of(context)!.supprimer,
                  style: Theme.of(Get.context!).textTheme.bodyMedium!)));
    }
    return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Icon(Icons.check,
                color: ThemeData().colorScheme.onSurface, size: width * 0.05),
            Text(AppLocalizations.of(context)!.amis,
                style: Theme.of(Get.context!).textTheme.bodySmall!)
          ],
        ));
  }

  Widget body(BuildContext context) {
    return Padding(
        padding: getPadding(right: 10, left: 10),
        child: SizedBox(
          width: width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profileImage(
                    image: controller.userResp.value!.profileImage,
                    size: width * 0.13),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgPicture.asset(
                    BlackIconConstant.logo,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ),
                  Text(
                    controller.userResp.value!.username!,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ]),
                controller.userResp.value!.description == ""
                    ? SizedBox()
                    : SizedBox(height: 10),
                Text(
                  controller.userResp.value!.description ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 10),
                Flexible(
                    child: controller.userResp.value!.friendStatus ==
                            FriendStatus.FRIEND
                        ? bodyIsFriend(context)
                        : bodyIsNotFriend())
              ]),
        ));
  }

  Widget bodyIsNotFriend() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.lock,
          size: 30,
        ),
        SizedBox(width: width * 0.1),
        Expanded(
            child: Text(
                AppLocalizations.of(Get.context!)!
                    .ce_compte_est_prive_ajoute_le_comme_ami_pour_voir_ses_blocs,
                maxLines: 2,
                overflow: TextOverflow.clip))
      ],
    );
  }

  Widget iconsText(String text, Widget icon, int number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        icon,
        Text(number.toString(), style: AppTextStyle.rb14),
        Text(text, style: AppTextStyle.rb14.copyWith(color: Colors.grey))
      ],
    );
  }

  Widget bodyIsFriend(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.ses_videos,
              style: Theme.of(context).textTheme.titleLarge!),
          SizedBox(height: 20),
          Obx(() => controller.videoList.length == 0
              ? Center(
                  child: Text(
                  AppLocalizations.of(context)!.pas_de_video_amis,
                  style: Theme.of(context).textTheme.bodySmall!,
                  textAlign: TextAlign.center,
                ))
              : SizedBox(
                  height: 150,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => VideoCapture(
                            'betaUsers',
                            wantKeepAlive: true,
                            controller: VideoPlayerController.networkUrl(
                                Uri.parse(controller.videoList[index].url)),
                            isReadOnly: true,
                          ),
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                      itemCount: controller.videoList.length))),
          SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.ses_blocs,
              style: Theme.of(context).textTheme.titleLarge!),
          SizedBox(height: 20),
          Container(
            height: height * 0.08,
            child: Obx(() => controller.gymLists.length == 0
                ? Center(
                    child: Text(
                    AppLocalizations.of(context)!.pas_de_blocs_amis,
                    style: Theme.of(context).textTheme.bodySmall!,
                    textAlign: TextAlign.center,
                  ))
                : ListView.separated(
                    itemCount: controller.gymLists.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (controller.displayGymList.value != null &&
                          controller.gymLists[index].id ==
                              controller.displayGymList.value?.id) {
                        return StatsWidgetGym(
                            onTap: () {},
                            climbingLocationMinimalResp:
                                controller.gymLists[index],
                            isActive: true);
                      }
                      return StatsWidgetGym(
                          onTap: () {
                            controller.displayGymList.value =
                                controller.gymLists[index];
                            controller.displayGymList.refresh();
                            controller.filterWalls();
                          },
                          climbingLocationMinimalResp:
                              controller.gymLists[index]);
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(width: width * 0.02),
                  )),
          ),
          SizedBox(height: 20),
          Flexible(
              child: SmartRefresher(
                  // onLoading: () async {
                  //   await controller
                  //       .get_userprofile(controller.userResp.value!.id!);
                  //   _refreshController.loadComplete();
                  // },
                  // onRefresh: () async {
                  //   await controller
                  //       .get_userprofile(controller.userResp.value!.id!);
                  //   _refreshController.refreshCompleted();
                  // },
                  footer: const ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    completeDuration: Duration(milliseconds: 500),
                  ),
                  enablePullUp: true,
                  physics: const BouncingScrollPhysics(),
                  controller: _refreshController,
                  child: ListView.separated(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      itemCount: controller.displayWallList.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              WallHistoryWidget(
                                controller.displayWallList[index],
                              ),
                            ]);
                      })))
        ]);
  }
}
