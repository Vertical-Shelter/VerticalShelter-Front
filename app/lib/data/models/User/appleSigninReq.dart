import 'package:dio/dio.dart';

class AppleSigninreq {
  String uid;
  String email;
  String displayName;
  String photoUrl;

  AppleSigninreq(
      {required this.uid,
      required this.email,
      required this.displayName,
      required this.photoUrl});

  FormData toFormData() {
    return FormData.fromMap({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    });
  }
}
