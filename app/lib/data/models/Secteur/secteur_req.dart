import 'package:dio/dio.dart';

class SecteurReq {
  final int? label;
  final String? newLabel;
  SecteurReq({
     this.label,
    required this.newLabel,
  });

 

  Future<FormData> toFormData() async {
    FormData formData = FormData.fromMap({
      'label': label,
      'newlabel': newLabel ?? '',
      
    });
    return formData;
  }
}
