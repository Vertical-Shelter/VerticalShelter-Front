import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInReq {
  User user;

  GoogleSignInReq({
    required this.user,
  });

  FormData toFormData() {
    final formData = FormData();
    if (user.displayName != null)
      formData.fields.add(MapEntry('displayName', user.displayName!));
    if (user.email != null) formData.fields.add(MapEntry('email', user.email!));
    if (user.photoURL != null)
      formData.fields.add(MapEntry('photoURL', user.photoURL!));
    formData.fields.add(MapEntry('uid', user.uid));
    return formData;
  }
}
