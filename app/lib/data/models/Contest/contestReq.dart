import 'dart:convert';
import 'dart:typed_data';
import 'package:app/data/models/Contest/userContestReq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestReq {
  String title;
  String description;
  Uint8List? image;
  DateTime date;
  // int duration;
  int price;
  List<Bloc> blocs;

  ContestReq(
      {required this.title,
      required this.description,
      required this.image,
      required this.blocs,
      required this.date,
      // required this.duration,
      required this.price});

  FormData toFormData() {
    var data = {
      "title": title,
      "blocs": json.encode(blocs
          .map((bloc) => {"numero": bloc.numero, "zones": bloc.zones})
          .toList()),
      "description": description,
      "date": date,
      // "duration": duration,
      "price": price,
    };

    if (image != null) {
      data["image"] = MultipartFile(image!,
          filename: "contest_${date}.jpg", contentType: "image/jpg");
    }
    FormData formData = FormData(data);

    return formData;
  }
}

class Bloc {
  int numero;
  int zones;
  
  Bloc({required this.numero, required this.zones});
}