import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/User/appleSigninReq.dart';
import 'package:app/data/models/User/createUser/create_user_req.dart';
import 'package:app/data/models/User/googleSignInReq.dart';
import 'package:app/data/models/User/skills_resp.dart';
import 'package:app/data/models/User/user_req.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/User/createUser/create_user_resp.dart';
import 'package:app/data/models/login/post_login_resp.dart';
import 'package:app/data/prefs/multi_account_management.dart';

Future<PostLoginResp> signInGoogle(GoogleSignInReq googleSignInReq) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost({}, googleSignInReq.toFormData(),
      LoginRespfromJson, api.config.baseUrl + '/signin-google/');
}

Future<PostLoginResp> signInApple(AppleSigninreq appleSigninreq) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost({}, appleSigninreq.toFormData(),
      LoginRespfromJson, api.config.baseUrl + '/signin-apple/');
}

Future<UserResp> user_me() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet<UserResp>(
      MyAuthToken(), {}, userResFromJson, api.config.user + 'me-new/');
}

Future<void> user_delete() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(MyAuthToken(), {}, api.config.user + 'me/');
}

Future<UserResp> user_put(UserReq userReq) async {
  ApiClient api = Get.find<ApiClient>();
  Map<String, String> headers = MyAuthToken();

  return await api.genericPatch(
    headers,
    await userReq.toFormData(),
    userResFromJson,
    api.config.user + 'me/',
  );
}

// DELETE CURRENT USER

Future<List<UserMinimalResp>> list_friend() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(
      MyAuthToken(), {}, userMinimalRespFromJson, api.config.userListFriend);
}

Future delete_friend(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, ((json) => null),
      api.config.friendrequest(id) + 'delete-friend/');
}

Future add_friend(String user_Id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, ((json) => null),
      api.config.friendrequest(user_Id) + 'add-friend/');
}

Future cancel_friend(String user_Id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, ((json) => null),
      api.config.friendrequest(user_Id) + 'cancel-friend/');
}

Future<List<UserMinimalResp>> list_friend_request() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, userMinimalRespFromJson,
      api.config.user + 'me/friend-request/');
}

Future accept_friend(String user_Id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, ((json) => null),
      api.config.friendrequest(user_Id) + 'accept-friend/');
}

Future refuser_friend(String user_Id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, ((json) => null),
      api.config.friendrequest(user_Id) + 'refuse-friend/');
}

Future<PostCreateUserResp> create_user(PostCreateUserReq userReq) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
      {}, await userReq.toFormData(), createFromJson, api.config.createUser);
}

// CLOC

Future<List<ClimbingLocationMinimalResp>> getMyCloc() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<ClimbingLocationMinimalResp>(
      MyAuthToken(),
      {},
      climbingLocationMinimalrespFromJson,
      api.config.user + 'me/climbingGymSent/');
}

Future<List<UserMinimalResp>> list_user_from_same_cloc() async {
  ApiClient api = Get.find<ApiClient>();
  String climbingLcoation_id =
      Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
  return await api.genericList(MyAuthToken(), {"cloc_id": climbingLcoation_id},
      userMinimalRespFromJson, api.config.user + 'get-user-by-cloc/');
}

//Skills

Future<List<SkillResp>> getMySkills() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<SkillResp>(
      MyAuthToken(), {}, skillRespFromJson, api.config.user + 'me/skills/');
}

// QR CODE

Future<String> scanQRCode(String user_Id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, ((json) => json['message']),
      "${api.config.baseUrl}/user/scanQrCode/",
      query: {'qrCode': user_Id});
}
