import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/User/user_resp.dart';

import '../../../core/app_export.dart';

Future<List<ClimbingLocationMinimalResp>> getUserCloc(String userId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<ClimbingLocationMinimalResp>(
      MyAuthToken(),
      {},
      climbingLocationMinimalrespFromJson,
      api.config.user + '$userId/climbingGymSent/');
}

Future<List<UserMinimalResp>> list_name(String? name) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {'name': name ?? ''},
      userMinimalRespFromJson, api.config.userlist);
}

Future<UserResp> user_get(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet<UserResp>(MyAuthToken(), {'user_id': id},
      userResFromJson, api.config.user );
}

Future<List<SentWallResp>> userGetHistory(
    int offset, String climbingLocationID, String userId) async {
  ApiClient api = Get.find<ApiClient>();
  Map<String, dynamic> query = {
    "limit": 10,
    "offset": offset,
    "climbingLocation_id": climbingLocationID
  };

  return await api.genericList(
    MyAuthToken(),
    query,
    sentWallRespFromJson,
    api.config.user + '$userId/wall/',
  );
}
