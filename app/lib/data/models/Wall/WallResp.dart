import 'dart:convert';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Comments/commentsResp.dart';
import 'package:app/data/models/Likes/likeResp.dart';
import 'package:app/data/models/Secteur/secteurResp.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/SprayWall/hold.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

WallResp createWallRespFromJson(Map<String, dynamic> json) {
  List<SentWallResp> listsentWalls = [];
  if (json["sentWalls"] != null) {
    for (var item in json["sentWalls"]) {
      listsentWalls.add(SentWallResp.fromJson(item));
    }
  }

  List<HoldResp> holds = [];
  if (json["holds"] != null) {
    for (var item in json["holds"]) {
      holds.add(HoldRespfromJson(item));
    }
  }

  List<LikeResp> likes = [];
  if (json["likes"] != null) {
    for (var item in json["likes"]) {
      likes.add(likeRespFromJson(item));
    }
  }

  List<CommentsResp> comments = [];
  if (json["comments"] != null) {
    for (var item in json["comments"]) {
      comments.add(commentsRespFromJson(item));
    }
  }

  double? points =
      json['points'] is int ? json['points'].toDouble() : json['points'];
  if (points != null && points > 1000) points = 1000;

  return WallResp(
    hold_to_take: json['hold_to_take'],
    routeSetterName: json['routesettername'] ?? "",
    likes: likes,
    comments: comments,
    routeSetter: json['routesetter'] == null
        ? null
        : userResFromJson(json['routesetter']),
    isActual: json['isActual'],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    isDone: json['isDone'],
    points: points,
    betaOuvreur: json['betaOuvreur'],
    sentWalls: listsentWalls,
    secteurResp:
        json['secteur'] == null ? null : secteurRespFromJson(json['secteur']),
    climbingLocation: json['climbingLocation'] == null
        ? null
        : climbingLocationMinimalrespFromJson(json['climbingLocation']),
    attributes:
        json['attributes'] == null ? [] : List<String>.from(json['attributes']),
    holds: holds,
    grade: json["grade"] == null ? null : gradeRespfromJson(json['grade']),
    id: json['id'],
    description: json['description'],
    gradeId: json['grade_id'],
    name: json['name'],
    isProject: json['isProject'] ?? false,
    nbRepetitions: json['nbRepetitions'] ?? 0,
    equivalentExte: json['equivalentExte'],
    equivalentExteMean: json['equivalentExteMean'] ?? "",
  );
}

class WallResp {
  final String? id;
  final String? gradeId;
  final GradeResp? grade;
  final SecteurResp? secteurResp;
  final ClimbingLocationMinimalResp? climbingLocation;

  final DateTime? date;
  final String? name;
  final String? description;
  final String? hold_to_take;
  final List<String> attributes;
  final List<SentWallResp> sentWalls;
  final String? equivalentExteMean;
  final Map? error;
  final UserResp? routeSetter;
  final String routeSetterName;
  final String? betaOuvreur;
  final int nbRepetitions;

  bool? isDone;
  final bool? isActual;
  final double? points;
  final bool? isProject;

  List<LikeResp> likes;
  List<CommentsResp> comments;

  final List<HoldResp> holds;
  final String? equivalentExte;



  WallResp({
    this.points,
    this.nbRepetitions = 0,
    this.routeSetter,
    this.routeSetterName = "",
    this.holds = const [],
    this.equivalentExteMean,
    this.date,
    this.likes = const [],
    this.comments = const [],
    this.isProject,
    this.name,
    this.equivalentExte,
    this.hold_to_take,
    this.gradeId,
    this.isActual,
    this.id,
    this.isDone,
    this.sentWalls = const [],
    this.description,
    this.secteurResp,
    this.climbingLocation,
    this.grade,
    this.attributes = const [],
    this.error,
    this.betaOuvreur,
  });
}

List<String> stringFromJson(Map<String, dynamic> json) {
  List<String> list = [];
  for (var item in json["attributes"]) {
    list.add(item.toString());
  }
  return list;
}
