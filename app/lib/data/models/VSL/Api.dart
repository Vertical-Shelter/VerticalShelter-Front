import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/VSL/GuildReq.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/data/models/VSL/VSLResp.dart';
import 'package:app/data/apiClient/api_client.dart';

import 'package:app/core/utils/headers.dart';
import 'package:app/data/prefs/pref_utils.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

Future<VSLresp> getVSL() async {
  ApiClient api = Get.find<ApiClient>();
  String url = api.config.baseUrl + '/vsl/';
  return await api.genericGet(MyAuthToken(), {}, VSLRespFromJson, url);
}

Future<List<GuildResp>> getListGuild(String vsl_id) async {
  ApiClient api = Get.find<ApiClient>();
  String url = '${api.config.baseUrl}/vsl/$vsl_id/guilds/';
  var res = await api.genericList(MyAuthToken(), {}, guildRespFromJson, url);
  return res;
}

Future<List<ClimbingLocationResp>> getClimbingLocations(String vsl_id) async {
  ApiClient api = Get.find<ApiClient>();
  String url = '${api.config.baseUrl}/vsl/$vsl_id/climbingLocations/';

  return await api.genericList(
    MyAuthToken(),
    {},
    climbingLocationrespFromJson,
    url,
  );
}

Future<List<GuildResp>> getMyGuild() async {
  ApiClient api = Get.find<ApiClient>();
  String url = api.config.baseUrl + '/vsl/my-guilds/';
  try {
    print("Fetching data from: $url");
    List<GuildResp> guilds =
        await api.genericList(MyAuthToken(), {}, guildRespFromJson, url);
    print("Data fetched successfully: ${guilds.length} guild(s)");
    return guilds;
  } catch (e, stackTrace) {
    print("Error in GetMyGuild: $e");
    print(stackTrace);
    rethrow;
  }
}

Future<GuildResp> createGuildPost(Guildreq wallReq, String vsl_id) async {
  ApiClient api = Get.find<ApiClient>();
  String url = '${api.config.baseUrl}/vsl/$vsl_id/guild/create/';

  return await api.genericPost(
    MyAuthToken(),
    await wallReq.toFormDataGuild(),
    guildRespFromJson,
    url,
  );
}

Future<GuildResp> joinGuildPost(
    {required String guild_id, required String vsl_id}) async {
  ApiClient api = Get.find<ApiClient>();

  String url = '${api.config.baseUrl}/vsl/$vsl_id/guild/$guild_id/join-qr/';

  return await api.genericGet(MyAuthToken(), null, guildRespFromJson, url);
}



Future<GuildResp> roleGuildPatch(String vsl_id, String guild_id, String role) async {
  ApiClient api = Get.find<ApiClient>();

  String url = '${api.config.baseUrl}/vsl/$vsl_id/guild/$guild_id/role';

  return await api.genericPatch(MyAuthToken(), {"role": role}, guildRespFromJson, url);
}

Future<void> joinRequestGuild(String vsl_id, String guild_id, String joinRequestReq) async {
  ApiClient api = Get.find<ApiClient>();
  String url = '${api.config.baseUrl}/vsl/$vsl_id/guild/$guild_id/ask-join/';
  
  await api.genericPost(
    MyAuthToken(),
    {'message': joinRequestReq}, 
    (response) => null, // Aucune réponse spécifique à traiter
    url,
  );
}
Future<List<String>> getVslInformation({required int edition}) async {
  ApiClient api = Get.find<ApiClient>();
  String language = Get.find<PrefUtils>().getLocal();
  String url = '${api.config.baseUrl}/vsl/information/';
  return await api.genericList(
      MyAuthToken(),
      {'language': language, 'edition': edition},
      (json) => json["html"]['path'],
      url);
}

Future<List<ClimbingLocationResp>> listVslClimbingLocations(
    {required String vsl_id}) async {
  ApiClient api = Get.find<ApiClient>();
  String url = '${api.config.baseUrl}/vsl/$vsl_id/climbingLocations/';
  return await api.genericList(
      MyAuthToken(), {}, climbingLocationrespFromJson, url);
}

Future<void> preRegisterVSL(String vsl_id) async {
  ApiClient api = Get.find<ApiClient>();
  String url = '${api.config.baseUrl}/vsl/$vsl_id/pre-register/';
  await api.genericPost(MyAuthToken(), null, (json) => null, url);
}
