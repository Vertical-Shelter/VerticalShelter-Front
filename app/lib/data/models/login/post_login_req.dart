import 'package:dio/dio.dart';

class PostLoginReq {
  String? email;
  String? password;

  PostLoginReq({this.email, this.password});

  PostLoginReq.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  FormData toFormData() {
    final Map<String, dynamic> data = {};
    if (this.email != null) {
      data['email'] = this.email;
    }
    if (this.password != null) {
      data['password'] = this.password;
    }
    return FormData.fromMap(data);
  }
}
