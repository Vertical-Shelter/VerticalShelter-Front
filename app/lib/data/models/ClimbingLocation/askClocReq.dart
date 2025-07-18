import 'package:dio/dio.dart';

class AskClocReq {
  String name;
  String city;
  String instagram;

  AskClocReq({
    required this.name,
    required this.city,
    required this.instagram,
  });

  FormData toFromData() {
    return FormData.fromMap({
      'name': name,
      'city': city,
      'instagram': instagram,
    });
  }
}
