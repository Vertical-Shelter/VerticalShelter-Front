import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/User/user_resp.dart';

Future<List<UserMinimalResp>> rankingGlobalApi(int offset) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {"offset": offset},
      userMinimalRespFromJson, api.config.globalRanking);
}

Future<List<UserMinimalResp>> rankingFriendsApi(int offset) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {"offset": offset},
      userMinimalRespFromJson, api.config.friendsRanking);
}

Future<List<UserMinimalResp>> rankingClimbingLocationApi(
    String id, int offset) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {"offset": offset},
      userMinimalRespFromJson, api.config.gymRanking(id));
}
