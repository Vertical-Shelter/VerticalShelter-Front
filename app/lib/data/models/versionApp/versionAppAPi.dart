import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/User/googleSignInReq.dart';
import 'package:app/data/models/versionApp/versionAppResp.dart';

Future<VersionAppResp> appleVerif() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(
      {}, {}, versionAppRespFromJson, api.config.baseUrl + '/version-apple/');
}
