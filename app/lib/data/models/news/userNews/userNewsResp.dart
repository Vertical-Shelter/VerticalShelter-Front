import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';

class UserNewsResp {
  final String? newsType;
  final UserMinimalResp? friendId;
  final String? friendsType;
  final DateTime? date;
  final Map<String, dynamic>? args;
  final NewsResp? news_id;
  final ContestResp? contest_id;
  final ClimbingLocationMinimalResp? climbingLocation;
  final String? climbingLocation_type;

  UserNewsResp({
    required this.newsType,
    this.news_id,
    this.friendId,
    this.friendsType = '',
    this.contest_id,
    this.climbingLocation,
    this.climbingLocation_type,
    this.date,
    this.args,
  });
}

UserNewsResp userNewsRespFromMap(Map<String, dynamic> json) => UserNewsResp(
      newsType: json["newsType"],
      contest_id: json["contest_id"] == null
          ? null
          : contestRespFromJson(json["contest_id"]),
      news_id:
          json["news_id"] == null ? null : newsRespFromJson(json["news_id"]),
      friendId: json["friend_id"] == null
          ? null
          : userMinimalRespFromJson(json["friend_id"]),
      friendsType: json["friends_type"],
      date: DateTime.parse(json["date"]),
      climbingLocation: json["gym_id"] == null
          ? null
          : climbingLocationMinimalrespFromJson(json["gym_id"]),
      climbingLocation_type: json["gym_type"],
      args: json["args"],
    );
