import 'package:dio/dio.dart';

class UserNewsReq {

  DateTime date;

  UserNewsReq({required this.date});

  toFormData() {
    FormData formData = FormData.fromMap({
      'date': date,
    });
    return formData;
  }

}