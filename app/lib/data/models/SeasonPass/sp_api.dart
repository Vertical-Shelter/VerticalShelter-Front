import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/SeasonPass/LevelResp.dart';
import 'package:app/data/models/SeasonPass/QuestResp.dart';
import 'package:app/data/models/SeasonPass/SeasonPass.dart';
import 'package:app/data/models/SeasonPass/UserQuestResp.dart';
import 'package:app/data/models/User/user_resp.dart';

Future<SeasonPassResp> seasonPassGet() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericGet(MyAuthToken(), {}, seasonPassRespFromJson,
      api.config.baseUrl + '/season_pass/');
}

Future<List<UserQuestResp>> quest_quo_Get() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, userQuestRespFromJson,
      api.config.user + 'quetes_quotidienne/');
}

Future<List<UserQuestResp>> quest_hebdo_Get() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, userQuestRespFromJson,
      api.config.user + 'quetes_hebdo/');
}

Future<List<UserQuestResp>> quest_unique_Get() async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericList(MyAuthToken(), {}, userQuestRespFromJson,
      api.config.user + 'quetes_unique/');
}

Future<void> claim_quete_quo(String queteId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, (a) {},
      api.config.user + 'quetes_quotidienne/' + queteId + '/claim/');
}

Future<void> claim_quete_hebdo(String queteId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, (a) {},
      api.config.user + 'quetes_hebdo/' + queteId + '/claim/');
}

Future<void> claim_quete_unique(String queteId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), {}, (a) {},
      api.config.user + 'quetes_unique/' + queteId + '/claim/');
}

Future<void> incr_quete_unique(String queteId) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPatch(MyAuthToken(), {}, (a) {},
      api.config.user + 'quetes_unique/' + queteId + '/increment/');
}

Future<LevelResp> claim_recompense(
    String spId, String levelId, String recompense_type) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
      MyAuthToken(),
      {},
      levelRespFromJson,
      api.config.user +
          'me/season_pass/' +
          spId +
          '/level/' +
          levelId +
          '/recompense/',
      query: {"recompense_type": recompense_type});
}
