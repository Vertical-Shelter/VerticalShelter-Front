import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';

/// Response of the sent wall creation or manipulation
class SentWallResp {
  String? id;
  UserMinimalResp? user;
  GradeResp? grade;
  DateTime? date;
  int? nTentative;
  String? beta;
  String? beta_url;
  WallResp? wall;
  String? grade_font;

  SentWallResp(
      {required this.id,
      required this.user,
      required this.wall,
      required this.grade,
      required this.date,
      required this.grade_font,
      required this.nTentative,
      required this.beta,
      required this.beta_url});

  factory SentWallResp.fromJson(Map<String, dynamic> json) {
    return SentWallResp(
      id: json['id'],
      wall: json['wall'] == null ? null : createWallRespFromJson(json['wall']),
      user: json['user'] == null ? null : userMinimalRespFromJson(json['user']),
      grade: json['grade'] == null ? null : GradeResp.fromJson(json['grade']),
      date: json['date'] == null ? null : DateTime.parse(json['date']),
      nTentative: json['nTentative'],
      beta: json['beta'],
      grade_font: json['grade_font'],
      beta_url: json['beta'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SentWallResp && other.id == id;
  }
}

SentWallResp sentWallRespFromJson(Map<String, dynamic> json) {
  return SentWallResp.fromJson(json);
}
