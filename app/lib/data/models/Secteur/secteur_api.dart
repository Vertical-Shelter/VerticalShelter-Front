import 'dart:io';

import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/models/Secteur/secteur_req.dart';
import 'package:app/data/models/Secteur/secteurResp.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

Future<SecteurResp> secteur_post(
    SecteurReq secteurReq, String climbing_pk) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(MyAuthToken(), await secteurReq.toFormData(),
      secteurRespFromJson, api.config.getClimbingLocSecteurUrl(climbing_pk));
}

Future<void> secteur_update(
    String climbing_pk, String secteur_pk, List<File> images) async {
  ApiClient api = Get.find<ApiClient>();
  FormData formData = FormData();
  for (var image in images) {
    formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last)));
  }
  return await api.genericPatch(MyAuthToken(), formData, (var a) {},
      api.config.getClimbingLocSecteurUrl(climbing_pk) + '$secteur_pk/');
}

Future<void> migrate_to_old_secteur(
    String climbing_pk, String secteur_pk) async {
  ApiClient api = Get.find<ApiClient>();
  return await api.genericPost(
      MyAuthToken(),
      {},
      (var a) {},
      api.config.getClimbingLocSecteurUrl(climbing_pk) +
          '$secteur_pk/migrate_to_old_secteur/');
}
