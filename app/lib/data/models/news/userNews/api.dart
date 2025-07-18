import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/news/userNews/userNeawsReq.dart';
import 'package:app/data/models/news/userNews/userNewsResp.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

Future<List<UserNewsResp>> listUserNews({int offset = 0}) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<UserNewsResp>(
    MyAuthToken(),
    {'offset': offset},
    userNewsRespFromMap,
    api.config.user + 'news/',
  );
}

// Future<void> setLastDateNews() async {
//   ApiClient api = Get.find<ApiClient>();
//   await api.genericPatch(
//       MyAuthToken(),
//       UserNewsReq(date: DateTime.now().toUtc()).toFormData(),
//       (json) => null,
//       api.config.user + 'news/setLastDateNews/');
// }
