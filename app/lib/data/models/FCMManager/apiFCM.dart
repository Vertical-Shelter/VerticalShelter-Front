import 'package:app/core/app_export.dart';
import 'package:app/data/models/FCMManager/FCMreq.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';

Future<void> sendFCMToServer() async {
  ApiClient api = Get.find<ApiClient>();
  var token = await FirebaseMessaging.instance.getToken();
  FCMReq req = FCMReq(token: token.toString());
  Get.find<PrefUtils>().setFCM(token.toString());
  return await api.genericPost(
      MyAuthToken(), req.toFormData(), (a) {},api.config.user + 'me/FcmToken/' );
}

Future deleteFCMToServer() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(
      MyAuthToken(), {}, api.config.user + 'me/FcmToken/') ;
}
