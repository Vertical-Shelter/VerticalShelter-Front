import 'package:app/data/models/Wall/WallResp.dart';
import 'dart:ui' as ui;

class ProjetResp {
  WallResp? wall;
  String? id;
  String? climbingLocation_id;
  String? secteur_id;
  bool is_sprayWall;
  ui.Image? image;

  ProjetResp(
      {this.wall,
      this.id,
      this.climbingLocation_id,
      this.secteur_id,
      this.is_sprayWall = false});
}

ProjetResp projetRespFromJson(Map<String, dynamic> json) {
  return ProjetResp(
    wall: json['wall_id'] != null
        ? createWallRespFromJson(json['wall_id'])
        : null,
    id: json['id'],
    climbingLocation_id: json['climbingLocation_id'],
    secteur_id: json['secteur_id'],
    is_sprayWall: json['is_spraywall'] ?? false,
  );
}
