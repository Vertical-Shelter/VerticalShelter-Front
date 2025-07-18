import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';

Future<void> logout() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
      MyAuthToken(), {}, (a) {}, api.config.baseUrl + '/logout/');
}
