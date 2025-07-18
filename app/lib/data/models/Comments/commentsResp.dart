import 'package:app/data/models/User/user_resp.dart';

class CommentsResp {
  String? id;
  String? message;
  String? date;
  UserMinimalResp? user;

  CommentsResp({this.id, this.message, this.date, this.user});
}

CommentsResp commentsRespFromJson(Map<String, dynamic> json) {
  return CommentsResp(
      id: json['id'],
      message: json['comment'] ?? "",
      date: json['date'],
      user: userMinimalRespFromJson(json['user']));
}
