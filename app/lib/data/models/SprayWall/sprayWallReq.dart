import 'dart:io';

import 'package:dio/dio.dart';

class SprayWallReq {
  File? imageFile;
  String? name;

  SprayWallReq({this.imageFile, this.name});

  FormData toFormData() {
    FormData formData = FormData.fromMap(
      {
        "label": name,
      },
    );
    if (imageFile != null) {
      formData.files.add(MapEntry(
        "image",
        MultipartFile.fromFileSync(imageFile!.path),
      ));
    }

    return formData;
  }
}
