import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/User/projet/projectReq.dart';
import 'package:app/data/models/User/projet/projetResp.dart';

Future<List<ProjetResp>> list_projets() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(
      MyAuthToken(), {}, projetRespFromJson, api.config.user + 'me/project/');
}

Future<ProjetResp> postProject(ProjectReq projectreq) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), projectreq.toJson(),
      projetRespFromJson, api.config.user + 'me/project/');
}

Future<void> deleteProject(String projectId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericDelete(
      MyAuthToken(), {"project_id" : projectId}, api.config.user + 'me/project/');
}
