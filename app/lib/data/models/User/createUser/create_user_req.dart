import 'package:dio/dio.dart';

class PostCreateUserReq {
  String email;
  String password;
  String password2;
  String username;

  PostCreateUserReq(
      {required this.email,
      required this.password,
      required this.password2,
      required this.username,
     });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = this.email;
    data['password'] = this.password;
    data['password2'] = this.password2;
    data['username'] = this.username;
    return data;
  }

  Future<FormData> toFormData() async {
    var map = Map<String, dynamic>();

    map['email'] = email;
    map['password'] = password;
    map['password2'] = password2;
    map['username'] = username;

    var formData = FormData.fromMap(map);

    return formData;
  }
}
