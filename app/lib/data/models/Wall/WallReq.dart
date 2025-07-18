import 'dart:convert';
import 'dart:io';

import 'package:app/data/models/grade/gradeResp.dart';
import 'package:dio/dio.dart';

class WallReq {
  String? id;
  String? description;
  String? hold_to_take;
  GradeResp? grade;
  List<String>? attributes;
  File? beta;
  String? ouvreurName;
  DateTime? date;

  WallReq({
    this.id,
    this.hold_to_take,
    this.beta,
    this.ouvreurName,
    this.description,
    this.grade,
    this.attributes,
    this.date,
  });

  bool isNull() {
    return (description == null &&
        hold_to_take == null &&
        grade == null &&
        attributes == null &&
        beta == null &&
        ouvreurName == null);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (id != null) {
      data['wall_id'] = id;
    }

    if (grade != null) {
      data['grade_id'] = grade!.id;
    }
    if (ouvreurName != null) {
      data['routesettername'] = ouvreurName;
    }

    if (description != null) {
      data['description'] = description;
    }
    print("dat =" + (date != null ? date.toString() : "null"));
    if (date != null) {
      data['date'] = date!.toIso8601String();
    }

    if (hold_to_take != null) {
      data['hold_to_take'] = hold_to_take;
    }

    if (attributes != null && attributes!.isNotEmpty) {
      data['attributes'] = attributes!.toList();
    }

    return data;
  }

  Future<FormData> toFormData() async {
    FormData formData = FormData.fromMap({
      'wall_data': jsonEncode(toJson()),
    });
    print('beta' + beta.toString());
    if (beta != null) {
      formData.files.add(MapEntry(
          'betaOuvreur',
          await MultipartFile.fromFile(beta!.path,
              filename: beta!.path.split('/').last)));
    }

    return formData;
  }
}
