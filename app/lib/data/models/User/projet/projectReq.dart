import 'package:dio/dio.dart';

class ProjectReq {
  String wall_id;
  String climbingLocation_id;
  String? secteur_id;
  bool isSprayWall = false;
  ProjectReq(
      {required this.wall_id,
      required this.climbingLocation_id,
      this.secteur_id,
      this.isSprayWall = false});

  String toJson() {
    return '{"wall_id": "$wall_id", "climbingLocation_id": "$climbingLocation_id", "secteur_id": "$secteur_id", "is_spraywall": $isSprayWall}';
  }
}
