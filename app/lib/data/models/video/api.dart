import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/video/videoResp.dart';

Future<List<VideoResp>> get_my_videos() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(
      MyAuthToken(), {}, videoRespFromJson, api.config.user + 'me/videos/');
}

Future<List<VideoResp>> get_user_videos(String userId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, videoRespFromJson,
      api.config.user + '$userId/videos/');
}
