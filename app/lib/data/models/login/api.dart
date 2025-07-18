import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/login/post_login_req.dart';
import 'package:app/data/models/login/post_login_resp.dart';

Future<PostLoginResp> loginAPI(PostLoginReq requestData) async {
  ApiClient api = Get.find<ApiClient>();

  return api.genericPost<PostLoginResp>(
      {}, requestData.toFormData(), LoginRespfromJson, api.config.loginUrl);
}
