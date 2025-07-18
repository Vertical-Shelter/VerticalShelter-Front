import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';

Future<List<NewsResp>> listNewsList(climbingLocationId) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericList({}, {}, newsRespFromJson,
      api.config.climbinglocation + '$climbingLocationId/news/');
}

Future<NewsResp> getNews(
    {required String climbingLocationId, required String newsId}) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericGet({}, {"news_id": newsId}, newsRespFromJson,
      api.config.climbinglocation + '$climbingLocationId/news/');
}

