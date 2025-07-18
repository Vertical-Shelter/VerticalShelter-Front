import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/ClimbingLocation/askClocReq.dart';

Future<ClimbingLocationResp> climbingLocation_get(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet<ClimbingLocationResp>(
      MyAuthToken(),
      {"climbingLocation_id": id},
      climbingLocationrespFromJson,
      api.config.climbinglocation);
}

Future<void> climbingLocation_put(String id, ClimbingLocationReq req) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(MyAuthToken(), await req.toFormData(),
      (var a) {}, api.config.climbinglocation + '$id/');
}

Future<ClimbingLocationResp> climbingLocation_addme_to_users(int id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(MyAuthToken(), {}, climbingLocationrespFromJson,
      api.config.climbinglocation + '$id/addme_to_users/');
}

Future<ClimbingLocationResp> climbingLocation_deleteme_from_users(
    int id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(MyAuthToken(), {}, climbingLocationrespFromJson,
      api.config.climbinglocation + '$id/deleteme_from_users/');
}

Future<List<ClimbingLocationResp>> climbinglocation_list_by_name(
    String? name) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList({}, {'name': name}, climbingLocationrespFromJson,
      api.config.climbinglocation + 'list-by-name/');
}

Future<void> askCloc(AskClocReq askClocReq) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), askClocReq.toFromData(),
      (var a) {}, api.config.baseUrl + '/demande-climbingLocation/');
}
