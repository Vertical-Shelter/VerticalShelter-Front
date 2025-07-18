import 'package:dio/dio.dart';

class ForgotPassWordReq {
  String email;

  ForgotPassWordReq({required this.email});

FormData toFormData() {
    var map = Map<String, dynamic>();

    map['email'] = email;

    var formData = FormData.fromMap(map);

    return formData;
  }
}