import 'package:dio/dio.dart';

class CommentsReq {
  String message;

  CommentsReq({required this.message});
  FormData toFormData() {
    var map = Map<String, dynamic>();

    map['comment'] = message;

    var formData = FormData.fromMap(map);

    return formData;
  }
}
