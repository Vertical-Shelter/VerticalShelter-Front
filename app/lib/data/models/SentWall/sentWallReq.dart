import 'dart:io';

import 'dart:convert';

import 'package:dio/dio.dart';

class SentWallReq {
  String? gradeID;
  int nTentative;
  DateTime date;
  File? beta;
  String? beta_url;
  String? id;
  String? grade_font;

  SentWallReq(
      {required this.gradeID,
      required this.nTentative,
      required this.date,
      this.grade_font,
      this.beta,
      this.beta_url,
      this.id});

  Future<Map<String, dynamic>> toJson() async {
    String base64Image = '';
    var req = {
      'grade_id': gradeID,
      'nTentative': nTentative,
      'date': date,
      'beta_url': beta_url,
      'grade_font': grade_font,
    };
    if (beta != null) {
      List<int> imageBytes = beta!.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      req['beta'] = base64Image;
    }
    return req;
  }

  Future<FormData> toFormData() async {
    FormData formData = FormData.fromMap({
      'grade_id': gradeID,
      'nTentative': nTentative,
      'date': date,
      'beta_url': beta_url,
      'grade_font': grade_font,
    });
    if (beta != null) {
      formData.files.add(MapEntry(
          'beta',
          await MultipartFile.fromFile(beta!.path,
              filename: beta!.path.split('/').last)));
    }
    return formData;
  }
}

Future<FormData> toFormDataList(List<SentWallReq> blocs) async {
  FormData formData = FormData.fromMap({
    "sentwalls": json.encode(blocs
        .map((bloc) => {
              "id": bloc.id,
              "nTentative": bloc.nTentative,
              "date": bloc.date.toIso8601String(),
              "grade_id": bloc.gradeID,
              "grade_font": bloc.grade_font,
            })
        .toList()),
  });
  return formData;
}
