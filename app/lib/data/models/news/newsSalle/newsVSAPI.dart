import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';

Future<List<NewsResp>> listNewsVSList() async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericList({}, {}, newsRespFromJson,
      api.config.baseUrl + '/verticalShelter/news/');
}

Future<NewsResp> getNewsVS({required String newsId}) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericGet({}, {"news_id": newsId}, newsRespFromJson,
       api.config.baseUrl + '/verticalShelter/news/');

}