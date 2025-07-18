import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/Likes/likeResp.dart';

Future<List<LikeResp>> getLikes(
  String ClimbingPk,
  String SecteurPk,
  String wall_pk,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<LikeResp>(
    MyAuthToken(),
    {},
    likeRespFromJson,
    api.config.getWallRouteSetterUrl(ClimbingPk, SecteurPk, wall_pk) + 'likes/',
  );
}

Future<LikeResp> postLikes(
  String ClimbingPk,
  String SecteurPk,
  String wall_pk,
) async {
  ApiClient api = Get.find<ApiClient>();
  var headers = MyAuthToken();
  headers.addAll({'Content-Type': 'application/json'});
  return await api.genericPost(
    MyAuthToken(),
    null,
    likeRespFromJson,
    api.config.getWallRouteSetterUrl(ClimbingPk, SecteurPk, wall_pk) + 'likes/',
  );
}

Future deleteLikes(
  String ClimbingPk,
  String SecteurPk,
  String wall_pk,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(
    MyAuthToken(),
    {},
    api.config.getWallRouteSetterUrl(ClimbingPk, SecteurPk, wall_pk) + 'likes/',
  );
}

Future<LikeResp> postSprayWallLike({
  required String climbingLocationId,
  required String sprayWallId,
  required String wallId,
}) async {
  ApiClient api = Get.find<ApiClient>();
  var headers = MyAuthToken();
  headers.addAll({'Content-Type': 'application/json'});
  return await api.genericPost(
    MyAuthToken(),
    null,
    likeRespFromJson,
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/' +
        wallId +
        '/likes/',
  );
}

Future deleteSprayWallLike({
  required String climbingLocationId,
  required String sprayWallId,
  required String wallId,
  required String likeId,
}) async {
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
        '/likes/' +
        likeId,
  );
}
