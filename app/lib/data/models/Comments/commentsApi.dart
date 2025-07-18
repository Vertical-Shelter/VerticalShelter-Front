import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/Comments/commentsReq.dart';
import 'package:app/data/models/Comments/commentsResp.dart';

Future<List<CommentsResp>> getComments(
  String ClimbingPk,
  String SecteurPk,
  String wall_pk,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<CommentsResp>(
    MyAuthToken(),
    {},
    commentsRespFromJson,
    api.config.getWallRouteSetterUrl(ClimbingPk, SecteurPk, wall_pk) +
        'comments/',
  );
}

Future<CommentsResp> postComment(String ClimbingPk, String SecteurPk,
    String wall_pk, CommentsReq comment) async {
  ApiClient api = Get.find<ApiClient>();
  var headers = MyAuthToken();
  headers.addAll({'Content-Type': 'application/json'});
  return await api.genericPost(
    MyAuthToken(),
    comment.toFormData(),
    commentsRespFromJson,
    api.config.getWallRouteSetterUrl(ClimbingPk, SecteurPk, wall_pk) +
        'comments/',
  );
}

Future<CommentsResp> postSprayWallComment(
    {required String climbingLocationId,
    required String sprayWallId,
    required String wallId,
    required CommentsReq comment}) async {
  ApiClient api = Get.find<ApiClient>();
  var headers = MyAuthToken();
  headers.addAll({'Content-Type': 'application/json'});
  return await api.genericPost(
    MyAuthToken(),
    comment.toFormData(),
    commentsRespFromJson,
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/' +
        wallId +
        '/comments/',
  );
}

// delete comment
Future<void> deleteComment(
  String ClimbingPk,
  String SecteurPk,
  String wall_pk,
  String comment_pk,
) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(
    MyAuthToken(),
    {"comment_id": comment_pk},
    api.config.getWallRouteSetterUrl(ClimbingPk, SecteurPk, wall_pk) +
        'comments/',
  );
}

Future<void> deleteSprayWallComment(
    {required String climbingLocationId,
    required String sprayWallId,
    required String wallId,
    required String commentId}) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(
    MyAuthToken(),
    {"comment_id": commentId},
    api.config.climbinglocation +
        climbingLocationId +
        '/spraywalls/' +
        sprayWallId +
        '/blocs/' +
        wallId +
        '/comments/' +
        commentId,
  );
}
