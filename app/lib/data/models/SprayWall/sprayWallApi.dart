import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/SprayWall/sprayWallBoulderReq.dart';
import 'package:app/data/models/SprayWall/sprayWallReq.dart';
import 'package:app/data/models/SprayWall/sprayWallResp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:get/get_core/src/get_main.dart';

// Future<List<SprayWallResp>> GetSprayWalls() async {
//   ApiClient api = Get.find<ApiClient>();
//   return await api.genericList(MyAuthToken(), {}, SpraywallRespFromJson,
//       api.config.climbinglocation + 'spraywalls/');
// }

Future<SprayWallResp> createSprayWall(
    SprayWallReq sprayWallReq, String climbingLocation) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
    MyAuthToken(),
    sprayWallReq.toFormData(),
    SpraywallRespFromJson,
    '${api.config.climbinglocation}$climbingLocation/spraywalls/',
  );
}

Future<SprayWallResp> update_spraywall(SprayWallReq sprayWallReq,
    String climbingLocation, String secteurId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(
    MyAuthToken(),
    sprayWallReq.toFormData(),
    SpraywallRespFromJson,
    '${api.config.climbinglocation}$climbingLocation/spraywalls/$secteurId/',
  );
}

Future<List<SprayWallResp>> ListSprayWalls(String climbingLocation) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, SpraywallRespFromJson,
      '${api.config.climbinglocation}$climbingLocation/spraywalls/');
}

Future<SprayWallResp> SprayWallDetails(
  String climbingLocation,
  String wallId,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(MyAuthToken(), {}, SpraywallRespFromJson,
      api.config.climbinglocation + climbingLocation + '/spraywalls/' + wallId);
}

Future<List<WallResp>> SprayWallListBloc(
    String climbingPk, String WallId, Map<String, dynamic> query) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(
    MyAuthToken(),
    query,
    createWallRespFromJson,
    api.config.climbinglocation +
        climbingPk +
        '/spraywalls/' +
        WallId +
        '/blocs/',
    //api.config.getClimbingLocSecteurUrl(climbingPk),
  );
}

Future<WallResp> createBlocPost(SprayWallBoulderReq wallReq,
    String climbingLocationId, String sprayWallId) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericPost(
    MyAuthToken(),
    await toFormDataSprayWall(wallReq),
    (d) => createWallRespFromJson(d),
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/',
  );
}

Future<WallResp> get_sprayWall_Wall(
    {required String wallId,
    required String climbingLocationId,
    required String sprayWallId}) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(
    MyAuthToken(),
    {},
    createWallRespFromJson,
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/' +
        wallId,
    //api.config.getClimbingLocSecteurUrl(climbingPk),
  );
}
