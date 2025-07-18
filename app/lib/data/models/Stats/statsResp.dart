import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Wall/WallResp.dart';

class WallStat {
  WallResp? wall;
  String? date;

  WallStat({this.wall, this.date});
}

WallStat createWallStatFromJson(Map<String, dynamic> json) {
  return WallStat(
      wall: createWallRespFromJson(json['wall']), date: json['date']);
}

class StatsResp {
  Map<String, dynamic>? obj;

  StatsResp({this.obj});
}

StatsResp statsRespFromJson(Map<String, dynamic> json) {
  Map<String, dynamic> list = {};
  for (var stats in json.entries) {
    if (stats.value is int)
      list[stats.key] = stats.value;
    else if (stats.value is List<dynamic>)
      list[stats.key] =
          stats.value.map((e) => createWallRespFromJson(e)).toList();
    else if (stats.value is Map<String, dynamic>) {
      try {
        list[stats.key] = climbingLocationMinimalrespFromJson(stats.value);
      } catch (e) {
        list[stats.key] = statsRespFromJson(stats.value).obj;
      }
    }
  }
  return StatsResp(obj: list);
}
