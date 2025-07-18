import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/Stats/statsResp.dart';

Future<List<WallStat>> statsGetWallWeek() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<WallStat>(
    MyAuthToken(),
    {},
    createWallStatFromJson,
    api.config.statsWallThisWeek,
  );
}

Future<List<WallStat>> statsGetMyWalls() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<WallStat>(
    MyAuthToken(),
    {},
    createWallStatFromJson,
    api.config.statsWallThisWeek,
  );
}

Future<List<SentWallResp>> statsGetHistory(int offset,
    {String? climbingLocationID}) async {
  ApiClient api = Get.find<ApiClient>();
  Map<String, dynamic> query = {"limit": 10, "offset": offset};
  if (climbingLocationID != null) {
    query["climbingLocation_id"] = climbingLocationID;
  }
  return await api.genericList(
    MyAuthToken(),
    query,
    sentWallRespFromJson,
    api.config.history,
  );
}

Future<StatsResp> statsGeneral(String? filter_by) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(
    MyAuthToken(),
    {"filter_by": filter_by},
    statsRespFromJson,
    api.config.statGlobal,
  );
}

Future<StatsResp> statsPerGym(String? filter_by) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(
    MyAuthToken(),
    {"filter_by": filter_by},
    statsRespFromJson,
    api.config.statPerGym,
  );
}

// Future<StatsResp> statsGetNumberOfSentByColorsVerticalShelter() async {
//   ApiClient api = Get.find<ApiClient>();
//   return await api.genericGet(
//     MyAuthToken(),
//     {},
//     statsRespFromJson,
//     api.config.statsNumberOfSentByColorsVerticalShelter,
//   );
// }
