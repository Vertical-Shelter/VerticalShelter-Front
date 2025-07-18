// import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/Wall/WallReq.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

Future<List<WallResp>> wall_routesetter_actual(
    String climbingPk, Map<String, dynamic> query) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<WallResp>(
    MyAuthToken(),
    query,
    createWallRespFromJson,
    api.config.listActualVS(climbingPk),
  );
}

Future<List<WallResp>> wall_routesetter_old(
    String climbingPk, Map<String, dynamic> query) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<WallResp>(
    MyAuthToken(),
    query,
    createWallRespFromJson,
    api.config.listOldVS(climbingPk),
  );
}

Future<List<WallResp>> wall_list_actual(
    String climbingPk, Map<String, dynamic> query) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<WallResp>(
    MyAuthToken(),
    query,
    createWallRespFromJson,
    api.config.getClimbingLocSecteurUrl(climbingPk),
  );
}

Future<WallResp> wall_get(
    String wallId, String ClimbingLocationId, String SecteurId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet<WallResp>(
      MyAuthToken(),
      {},
      createWallRespFromJson,
      api.config.getWallRouteSetterUrl(ClimbingLocationId, SecteurId, wallId));
}

Future<WallResp> wall_post(
    WallReq wallReq, String climbingPk, String secteurPK) async {
  ApiClient api = Get.find<ApiClient>();
  var headers = await MyAuthToken();
  headers.addAll({'Content-Type': 'application/json'});

  return await api.genericPost(MyAuthToken(), await wallReq.toFormData(),
      createWallRespFromJson, api.config.wallSecteur(climbingPk, secteurPK));
}

Future<WallResp> wall_put(
  WallReq wallReq,
  String wallId,
  String ClimbingLocationId,
  String SecteurId,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(
      MyAuthToken(),
      await wallReq.toFormData(),
      createWallRespFromJson,
      api.config.getWallRouteSetterUrl(ClimbingLocationId, SecteurId, wallId));
}

Future<List<String>> list_attributes() async {
  ApiClient api = Get.find<ApiClient>();
  String climbingLocationId = Get.find<MultiAccountManagement>()
      .actifAccount!
      .climbingLocationId
      .toString();
  return await api.genericGet(MyAuthToken(), {}, stringFromJson,
      api.config.climbinglocation + climbingLocationId + '/attributes/');
}

Future<List<WallResp>> list_by_name(String? name) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {'name': name},
      createWallRespFromJson, api.config.wallNoClimbingLoc + 'list_by_name/');
}

Future<void> deleteWallApi(
    String wallId, String ClimbingLocationId, String SecteurId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(MyAuthToken(), {},
      api.config.getWallRouteSetterUrl(ClimbingLocationId, SecteurId, wallId));
}

Future<List<WallResp>> list_sent() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, createWallRespFromJson,
      api.config.wallNoClimbingLoc + 'get_sent/');
}

Future<List<WallResp>> list_like() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, createWallRespFromJson,
      api.config.wallNoClimbingLoc + 'get_liked/');
}
