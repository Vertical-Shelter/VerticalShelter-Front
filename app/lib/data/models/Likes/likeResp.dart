import 'package:app/data/models/User/user_resp.dart';

class LikeResp {
  String? date;
  UserMinimalResp? user;
  String? id;

  LikeResp({
    this.date,
    this.user,
    this.id,
  });
}

LikeResp likeRespFromJson(Map<String, dynamic> json) {
  return LikeResp(
      date: json['date'],
      user: userMinimalRespFromJson(json['user']),
      id: json['id']);
}
