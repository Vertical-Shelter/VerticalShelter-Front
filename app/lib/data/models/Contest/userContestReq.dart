import 'dart:convert';

import 'package:dio/dio.dart';

class UserContestReq {
  String genre;
  String prenom;
  String nom;
  bool isMemberShip;
  String? phaseId;
  bool is18YO;

  UserContestReq({
    required this.genre,
    required this.prenom,
    required this.isMemberShip,
    required this.nom,
    required this.phaseId,
    required this.is18YO,
  });

  FormData toFormData() {
    var data = {
      "genre": genre,
      "prenom": prenom,
      "nom": nom,
      "phaseId": phaseId,
      "is18YO": is18YO,
      "isMember": isMemberShip,
    };

    FormData formData = FormData.fromMap(data);

    return formData;
  }
}

class IsBlocSucceedReq {
  String blocId;
  bool isSucceed;
  List<bool>? isZoneSucceed;

  IsBlocSucceedReq({
    required this.blocId,
    required this.isSucceed,
    this.isZoneSucceed,
  });

  @override
  String toString() {
    // TODO: implement toString

    return "blocId: $blocId, isSucceed: $isSucceed, isZoneSucceed: $isZoneSucceed";
  }

  FormData toFormData() {
    var data = {
      "blocId": blocId,
      "isSucceed": isSucceed,
      "isZoneSucceed": isZoneSucceed,
    };

    FormData formData = FormData.fromMap(data);

    return formData;
  }
}

class ScoreReq {
  List<IsBlocSucceedReq> score;

  ScoreReq({
    required this.score,
  });

  FormData toFormData() {
    var data = {
      "score": json.encode(score
          .map((bloc) => {
                "blocId": bloc.blocId,
                "isSucceed": bloc.isSucceed,
                "isZoneSucceed": bloc.isZoneSucceed
              })
          .toList())
    };

    FormData formData = FormData.fromMap(data);

    return formData;
  }
}
