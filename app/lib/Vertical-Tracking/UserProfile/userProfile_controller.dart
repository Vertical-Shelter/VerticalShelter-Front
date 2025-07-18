import 'dart:io';

import 'package:app/Vertical-Tracking/Social/SocialController.dart';
import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/userApi.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/video/api.dart';
import 'package:app/data/models/video/videoResp.dart';
import 'package:app/widgets/ConfirmDialog.dart';
import 'package:app/widgets/friendButton.dart';
import 'package:app/widgets/settingmenu.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

enum ProfilWidgetType { FRIEND, NOT_FRIEND, ME }

class VTUserProfilController extends GetxController {
  RxBool is_loading = true.obs;
  Rxn<UserResp> userResp = Rxn<UserResp>();
  RxList<WallResp> displayWallList = <WallResp>[].obs;
  Rxn<ClimbingLocationMinimalResp> displayGymList =
      Rxn<ClimbingLocationMinimalResp>();
  RxInt numberOfBoulder = 0.obs;
  RxList<ClimbingLocationMinimalResp> gymLists =
      <ClimbingLocationMinimalResp>[].obs;
  RxList<WallResp> wallLists = <WallResp>[].obs;
  RxList<VideoResp> videoList = <VideoResp>[].obs;
  List<SettingMenuElement> settingMenu = [
    SettingMenuElement(
        icon: Icon(
          Icons.warning,
          color: Colors.red,
        ),
        text: AppLocalizations.of(Get.context!)!.signaler,
        onPressed: (BuildContext context) => null),
  ];
  RxBool is_loading_top = true.obs;

  CacheManager cacheManager = DefaultCacheManager();

  RxList<WallResp> projetList = <WallResp>[].obs;
  @override
  void onReady() async {
    String id = Get.parameters['id']!;
    await get_userprofile(id);

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void filterWalls() {
    displayWallList.clear();
    wallLists.forEach((element) {
      if (displayGymList.value == null ||
          element.climbingLocation!.id == displayGymList.value!.id) {
        displayWallList.add(element);
      }
    });
  }

  void acceptFriend(String id) async {
    try {
      SocialController socialController = Get.find<SocialController>();
      socialController.pending_friends
          .removeWhere((element) => element.id == id);
      socialController.friends.add(userResp.value!.toUserMinimalResp());
      socialController.displayFriends.add(userResp.value!.toUserMinimalResp());
      socialController.displayFriends.refresh();
      socialController.pending_friends.refresh();
      socialController.userCloc
          .where((element) => element.id == id)
          .forEach((element) {
        element.friendStatus = FriendStatus.FRIEND;
      });
      socialController.userCloc.refresh();
      userResp.value!.friendStatus = FriendStatus.FRIEND;
      userResp.refresh();
      accept_friend(id);
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

  Future<void> get_userprofile(String id) async {
    try {
      userResp.value = await user_get(id);
      videoList.clear();
      videoList.value = await get_user_videos(id);
      numberOfBoulder.value = userResp.value!.sentWalls!.length;

      if (userResp.value!.sentWalls!.isEmpty) {
        is_loading.value = false;
        is_loading.refresh();
        return;
      }
      userResp.value!.sentWalls!.forEach((element) {
        if (!gymLists.any(
            (element2) => element2.id == element.wall!.climbingLocation!.id)) {
          if (element.wall != null && element.wall!.climbingLocation != null) {
            gymLists.add(element.wall!.climbingLocation!);
          }
        }
        if (!wallLists.any((element2) => element2.id == element.wall!.id)) {
          if (element.wall != null) {
            wallLists.add(element.wall!);
          }
        }
      });
      if (gymLists.isNotEmpty) {
        displayGymList.value = gymLists[0];
      }
      filterWalls();
      numberOfBoulder.refresh();
      wallLists.refresh();
      is_loading.value = false;
      is_loading.refresh();
    } catch (e) {
      rethrow;
    }
  }

  void cancelFriend(String id) async {
    try {
      userResp.value!.friendStatus = FriendStatus.NOT_FRIEND;
      userResp.refresh();
      cancel_friend(id);
      SocialController socialController = Get.find<SocialController>();
      socialController.pending_friends
          .removeWhere((element) => element.id == id);
      socialController.pending_friends.refresh();
      socialController.userCloc
          .where((element) => element.id == id)
          .forEach((element) {
        element.friendStatus = FriendStatus.NOT_FRIEND;
      });
      socialController.userCloc.refresh();
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

  void addFriend(String id) async {
    try {
      userResp.value!.friendStatus = FriendStatus.REQUESTED;
      userResp.refresh();
      add_friend(id);
      SocialController socialController = Get.find<SocialController>();
      socialController.pending_friends.add(userResp.value!.toUserMinimalResp());
      socialController.pending_friends.refresh();
      socialController.userCloc
          .where((element) => element.id == id)
          .forEach((element) {
        element.friendStatus = FriendStatus.REQUESTED;
      });
      socialController.userCloc.refresh();
    } on SocketException {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.pas_de_connexion_internet,
          snackPosition: SnackPosition.TOP);
    }
  }

  void deleteFriend(BuildContext context, String id) async {
    await showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
            title:
                '${AppLocalizations.of(Get.context!)!.supprimer} ${userResp.value!.username ?? AppLocalizations.of(Get.context!)!.cet_utilisateur} ${AppLocalizations.of(Get.context!)!.de_vos_amis} ?',
            onConfirm: (context) async {
              try {
                delete_friend(id);
                userResp.value!.friendStatus = FriendStatus.NOT_FRIEND;
                userResp.refresh();
                SocialController socialController =
                    Get.find<SocialController>();
                socialController.friends
                    .removeWhere((element) => element.id == id);
                socialController.displayFriends
                    .removeWhere((element) => element.id == id);
                socialController.displayFriends.refresh();
                socialController.userCloc
                    .where((element) => element.id == id)
                    .forEach((element) {
                  element.friendStatus = FriendStatus.NOT_FRIEND;
                });
                socialController.userCloc.refresh();
              } on SocketException {
                Get.snackbar(
                    AppLocalizations.of(Get.context!)!.erreur,
                    AppLocalizations.of(Get.context!)!
                        .pas_de_connexion_internet,
                    snackPosition: SnackPosition.TOP);
              }
              Navigator.of(context).pop();
            }));
  }

  onTapBackButton() {
    Get.back();
  }

  OnTapMenuButton(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => SettingMenuWidget(elements: settingMenu));
  }
}
