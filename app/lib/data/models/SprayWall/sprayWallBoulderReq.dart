import 'dart:convert';
import 'dart:io';

import 'package:app/data/models/SprayWall/hold.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:dio/dio.dart';

class SprayWallBoulderReq {
  SprayWallBoulderMinimalReq spraywall_bloc;
  File? betaOuvreur;
  String? beta_url;

  SprayWallBoulderReq({
    required this.spraywall_bloc,
    this.betaOuvreur,
    this.beta_url,
  });
}

Future<FormData> toFormDataSprayWall(SprayWallBoulderReq req) async {
  // FormData formData = FormData.fromMap({
  //   "spraywall_bloc": jsonEncode(req.spraywall_bloc),
  //   "betaOuvreur": json.encode(req.betaOuvreur),
  //   "beta_url": json.encode(req.beta_url),
  // });
  FormData formData = FormData.fromMap({
    "spraywall_bloc": jsonEncode({
      "description": req.spraywall_bloc.description,
      "grade_id": req.spraywall_bloc.gradeId,
      "name": req.spraywall_bloc.name,
      "attributes": req.spraywall_bloc.attributes,
      "equivalentExte": req.spraywall_bloc.equivalentExte,
      "holds": req.spraywall_bloc.holds
          ?.map((hold) =>
              {"id": hold.id, "type": hold.type}) // Map each hold object
          .toList(),
      "date": req.spraywall_bloc.date,
    }),
    "beta_url": req.beta_url,
  });

  if (req.betaOuvreur != null) {
    formData.files.add(MapEntry(
      "betaOuvreur",
      MultipartFile.fromFileSync(req.betaOuvreur!.path),
    ));
  }
  return formData;
  // }

  //return formData;
}

class SprayWallBoulderMinimalReq {
  String? description;
  String gradeId;
  List<HoldResp>? holds;
  String? date;
  String name;
  List<String> attributes;
  String? equivalentExte;

  SprayWallBoulderMinimalReq({
    this.description,
    required this.gradeId,
    required this.name,
    this.equivalentExte,
    required this.attributes,
    this.holds,
    this.date,
  });
}
