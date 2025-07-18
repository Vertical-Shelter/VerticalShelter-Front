import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/Contest/contestReq.dart';
import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/models/Contest/userContestReq.dart';
import 'package:app/data/models/Contest/userContestResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';

Future<List<ContestResp>> listContestList(climbingLocationId) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericList(MyAuthToken(), {}, contestRespFromJson,
      api.config.climbinglocation + '$climbingLocationId/contest/');
}

Future<ContestResp> getContest(
    {required String climbingLocationId, required String contestId}) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericGet(
      MyAuthToken(),
      {"contest_id": contestId},
      contestRespFromJson,
      api.config.climbinglocation + '$climbingLocationId/contest/');
}

Future<ContestResp> subscribeToContest(String climbingLocationId,
    String contestId, UserContestReq userContestReq) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericPost(
      MyAuthToken(),
      userContestReq.toFormData(),
      contestRespFromJson,
      api.config.climbinglocation +
          '$climbingLocationId/contest/${contestId}/inscription/');
}

Future unSubscribeToContest(String climbingLocationId, String contestId) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericDelete(
      MyAuthToken(),
      {},
      api.config.climbinglocation +
          '$climbingLocationId/contest/${contestId}/inscription/');
}

Future<ContestResp> qrCodeScanned(
    String climbingLocationId, String contestId) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericPost(
      MyAuthToken(),
      {},
      contestRespFromJson,
      api.config.climbinglocation +
          '$climbingLocationId/contest/${contestId}/qrCodeScan/');
}

Future<UserContestResp> postScore(
    String climbingLocationId, String contestId, ScoreReq scoreReq) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericPost(
      MyAuthToken(),
      scoreReq.toFormData(),
      userContestRespFromJson,
      api.config.climbinglocation +
          '$climbingLocationId/contest/${contestId}/score/');
}

Future<List<UserContestResp>> resultatScore(
    String climbingLocationId, String contestId, String filter) async {
  ApiClient api = Get.find<ApiClient>();

  return await api.genericList(
      MyAuthToken(),
      {"filter": filter},
      userContestRespFromJson,
      api.config.climbinglocation +
          '$climbingLocationId/contest/${contestId}/resultat/');
}
