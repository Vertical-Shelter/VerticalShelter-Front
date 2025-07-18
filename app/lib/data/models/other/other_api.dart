import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';

Future<void> trackQrCode(Uri url) async {
  ApiClient api = Get.find<ApiClient>();
  try {
    return await api.genericGet(MyAuthToken(), {}, (a) {}, url.toString());
  } catch (e) {}
}
