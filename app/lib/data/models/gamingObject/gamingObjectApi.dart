import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/gamingObject/avatarResp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';

//Get all avatars

Future<List<AvatarResp>> getAvatars() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<AvatarResp>(
    MyAuthToken(),
    {},
    avatarRespFromJson,
    api.config.baseUrl + '/avatar/',
  );
}

Future<List<BaniereResp>> getBanieres() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<BaniereResp>(
    MyAuthToken(),
    {},
    baniereRespFromJson,
    api.config.baseUrl + '/baniere/',
  );
}

//buy avatar with id
Future<AvatarResp> buyAvatarAPI(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, avatarRespFromJson,
      api.config.baseUrl + '/avatar/buy/',
      query: {'avatar_id': id});
}

//select avatar with id
Future<AvatarResp> selectAvatarAPI(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, avatarRespFromJson,
      api.config.baseUrl + '/user/avatar/select/',
      query: {'avatar_id': id});
}

//buy avatar with id
Future<List<AvatarResp>> getMyAvatars() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(
    MyAuthToken(),
    {},
    avatarRespFromJson,
    api.config.baseUrl + '/user/avatar/',
  );
}

//buy baniere with id
Future<BaniereResp> buyBaniereAPI(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, baniereRespFromJson,
      api.config.baseUrl + '/baniere/buy/',
      query: {'baniere_id': id});
}

//buy baniere with id
Future<BaniereResp> selectBAniereAPI(String id) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, baniereRespFromJson,
      api.config.baseUrl + '/user/baniere/select/',
      query: {'baniere_id': id});
}

Future<List<BaniereResp>> getMyBanieresAPI() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList<BaniereResp>(
    MyAuthToken(),
    {},
    baniereRespFromJson,
    api.config.baseUrl + '/user/baniere/',
  );
}
