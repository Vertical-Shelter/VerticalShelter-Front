import 'dart:convert';

import 'package:dio/dio.dart';

class Guildreq {
  String climbingLocation_id;
  String name;
  String image_url;

  Guildreq(
      {required this.climbingLocation_id,
      required this.name,
      required this.image_url});

  Future<FormData> toFormDataGuild() async {
    // Crée un objet FormData avec les champs de la classe Guildreq

    dynamic json = {'climbingLocation_id': climbingLocation_id, 'name': name};

    final formData = FormData.fromMap({
      'guild': jsonEncode(json),
    });

    // Si l'image est définie, on l'ajoute à formData
    if (image_url.isNotEmpty) {
      final image = await MultipartFile.fromFile(image_url);
      formData.files.add(MapEntry('image', image));
    }
    return formData;
  }
}
