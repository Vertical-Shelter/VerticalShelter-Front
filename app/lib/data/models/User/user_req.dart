import 'dart:io';

import 'package:dio/dio.dart';

// import 'package:app/core/app_export.dart';

class UserReq {
  final String? username;
  final File? profileImage;
  final String? description;
  final String? FCMToken;
  final String? climbingLocation_id;

  UserReq({
    this.username,
    this.profileImage,
    this.description,
    this.climbingLocation_id,
    this.FCMToken,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();
    if (climbingLocation_id != null) {
      formData.fields
          .add(MapEntry('climbingLocation_id', climbingLocation_id!));
    }
    if (profileImage != null) {
      formData.files.add(MapEntry(
          'profile_image',
          await MultipartFile.fromFile(profileImage!.path,
              filename: profileImage!.path.split('/').last)));
    }
    if (username != null) formData.fields.add(MapEntry('username', username!));
    if (FCMToken != null)
      formData.fields.add(MapEntry('FCMTOKEN', FCMToken.toString()));

    if (description != null)
      formData.fields.add(MapEntry('description', description.toString()));

    return formData;
  }
}
