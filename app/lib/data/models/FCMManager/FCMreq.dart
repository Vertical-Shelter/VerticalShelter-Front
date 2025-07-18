import 'package:dio/dio.dart';

class FCMReq {
  String token;

  FCMReq({required this.token});

  FormData toFormData() {
    FormData formData = FormData.fromMap({
      'fcm_token': token,
    });
    return formData;
  }
}
