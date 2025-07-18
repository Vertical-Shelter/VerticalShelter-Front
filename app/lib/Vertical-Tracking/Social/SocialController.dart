import 'dart:io';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/userApi.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/VSL/Api.dart';
import 'package:app/data/models/VSL/VSLResp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/VSLController.dart';

class SocialController extends GetxController {
  RxBool isFriendLoading = true.obs;
  RxBool isUserClocLoading = true.obs;

  Vslcontroller vsl = Get.put(Vslcontroller());

  RxBool isInit = false.obs;
  RxBool isFocusing = false.obs;
  RxList<UserMinimalResp> pending_friends = <UserMinimalResp>[].obs;
  TextEditingController? searchTextControler = TextEditingController();
  RxList<UserMinimalResp> global = <UserMinimalResp>[].obs;
  RxList<UserMinimalResp> userCloc = <UserMinimalResp>[].obs;
  List<UserMinimalResp> friends = [];
  RxList<UserMinimalResp> displayFriends = <UserMinimalResp>[].obs;
  final BuildContext context = Get.context!;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> initController() async {
    pending_friends.value = await list_friend_request();
    pending_friends.forEach((element) {
      element.friendStatus = FriendStatus.PENDING;
    });

    String my_id = Get.find<MultiAccountManagement>().actifAccount!.id;

    pending_friends.removeWhere((element) => element.id == my_id);

    friends = await list_friend();
    friends.removeWhere((element) => element.id == my_id);

    displayFriends.value = friends;
    displayFriends.refresh();
    isFriendLoading.value = false;
    if (Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId !=
        "") {
      userCloc.value = await list_user_from_same_cloc();
      userCloc.refresh();
      userCloc.removeWhere((element) => element.id == my_id);
      isUserClocLoading.value = false;
    }
  }

  Future searchFriend(String p0) async {
    displayFriends.value = friends
        .where((element) =>
            element.username!.toLowerCase().contains(p0.toLowerCase()))
        .toList();
    // global.value = await list_name(p0);
  }

  Future searchGlobal(String p0) async {
    global.value = await list_name(p0);
  }

  void acceptFriend(String id) async {
    try {
      UserMinimalResp userMinimalResp =
          pending_friends.firstWhere((element) => element.id == id);
      pending_friends.removeWhere((element) => element.id == id);
      pending_friends.refresh();
      friends.add(userMinimalResp);
      displayFriends.refresh();
      pending_friends.refresh();
      userCloc.where((element) => element.id == id).forEach((element) {
        element.friendStatus = FriendStatus.FRIEND;
      });
      userCloc.refresh();
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

  void refuseFriend(String id) async {}

  void cancelFriend(String id) async {
    try {
      cancel_friend(id);
      pending_friends.removeWhere((element) => element.id == id);
      pending_friends.refresh();
      userCloc.where((element) => element.id == id).forEach((element) {
        element.friendStatus = FriendStatus.NOT_FRIEND;
      });
      userCloc.refresh();
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
      add_friend(id);

      userCloc.where((element) => element.id == id).forEach((element) {
        element.friendStatus = FriendStatus.REQUESTED;
      });
      userCloc.refresh();
    } on SocketException {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.pas_de_connexion_internet,
          snackPosition: SnackPosition.TOP);
    }
  }

 
}
