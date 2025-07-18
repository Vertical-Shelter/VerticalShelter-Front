import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/ForgotPassword/forgotPasswordReq.dart';
import 'package:app/data/models/ForgotPassword/forgotPasswordResp.dart';
import 'package:get/get.dart';

Future<ForgotPasswordResp> resetPassword(ForgotPassWordReq req) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost({}, await req.toFormData(),
      forgotPasswordRespFromJson, api.config.baseUrl + '/reset_password/');
}
