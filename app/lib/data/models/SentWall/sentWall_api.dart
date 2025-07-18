import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/SentWall/sentWallReq.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';

Future<SentWallResp> sent_it(SentWallReq req, String climbingLocPk,
    String secteurPk, String wallPk) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
      MyAuthToken(),
      await req.toFormData(),
      sentWallRespFromJson,
      api.config.getWallRouteSetterUrl(climbingLocPk, secteurPk, wallPk) +
          'sentwall/');
}

Future<void> sent_itList(
  List<SentWallReq> req,
  String climbingLocPk,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), await toFormDataList(req), (d) {
    return null;
  }, api.config.climbinglocation + climbingLocPk + '/sentwall/');
}

Future unsent_it(String climbingLocPk, String secteurPk, String wallPk,
    String sentId) async {
  ApiClient api = Get.find<ApiClient>();
  await api.genericDelete(MyAuthToken(), {},
      api.config.sentWallsManip(climbingLocPk, secteurPk, wallPk, sentId));
}

Future<SentWallResp> patch_sent_it(SentWallReq req, String climbingLocPk,
    String secteurPk, String wallPk, String SentWallId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(
      MyAuthToken(),
      await req.toFormData(),
      sentWallRespFromJson,
      api.config.getWallRouteSetterUrl(climbingLocPk, secteurPk, wallPk) +
          'sentwall/$SentWallId/');
}

Future<SentWallResp> get_sent_it(String wallID, String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(MyAuthToken(), {}, sentWallRespFromJson,
      api.config.wallNoClimbingLoc + '$wallID/sent/$id/');
}

Future<SentWallResp> sentSprayWallDetails(SentWallReq req,
    String climbingLocationId, String sprayWallId, String wallId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
    MyAuthToken(),
    await req.toFormData(),

    sentWallRespFromJson,
    // ignore: prefer_interpolation_to_compose_strings
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/' +
        wallId +
        "/sentwall/",
  );
}

//Patch sprayWall

Future<SentWallResp> patchSprayWallDetails(
    SentWallReq req,
    String climbingLocationId,
    String sprayWallId,
    String wallId,
    String sentWallId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(
    MyAuthToken(),
    await req.toFormData(),
    sentWallRespFromJson,
    // ignore: prefer_interpolation_to_compose_strings
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/' +
        wallId +
        "/sentwall/",
  );
}

//Delete spray Wall sent
Future<void> deleteSprayWallSent(
    String climbingLocationId, String sprayWallId, String wallId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(
      MyAuthToken(),
      {},
      api.config.climbinglocation +
          climbingLocationId +
          '/spraywalls/' +
          sprayWallId +
          '/blocs/' +
          wallId +
          "/sentwall/");
}
