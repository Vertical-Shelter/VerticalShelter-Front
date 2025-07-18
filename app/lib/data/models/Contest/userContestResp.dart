import 'package:app/core/app_export.dart';
import 'package:app/data/models/Contest/userContestReq.dart';
import 'package:app/data/models/User/user_resp.dart';

class UserContestResp {
  String? genre;
  String? nom;
  String? prenom;
  UserMinimalResp? user;
  double? points;
  List<IsBlocSucceedResp>? isBlocSucceed = [];

  UserContestResp({
    required this.genre,
    required this.nom,
    required this.prenom,
    required this.user,
    required this.isBlocSucceed,
    required this.points,
  });
}

UserContestResp userContestRespFromJson(Map<String, dynamic> json) {
  return UserContestResp(
    genre: json['genre'],
    isBlocSucceed: json['blocs'] != null
        ? List<IsBlocSucceedResp>.from(
            json['blocs'].map((x) => isBlocSucceedFromJson(x)).toList())
        : [],
    nom: json['nom'],
    prenom: json['prenom'],
    points: json['points'] != null ? json['points'].toDouble() : null,
    user: json['user'] != null ? userMinimalRespFromJson(json['user']) : null,
  );
}

class IsBlocSucceedResp {
  String blocId;
  bool isSucceed;
  List<bool>? isZoneSucceed;

  IsBlocSucceedResp({
    required this.blocId,
    required this.isSucceed,
    this.isZoneSucceed,
  });
}

IsBlocSucceedResp isBlocSucceedFromJson(Map<String, dynamic> json) {
  return IsBlocSucceedResp(
    blocId: json['blocId'],
    isSucceed: json['isSucceed'],
    isZoneSucceed: json['isZoneSucceed'] != null
        ? List<bool>.from(json['isZoneSucceed'].map((x) => x))
        : [],
  );
}
