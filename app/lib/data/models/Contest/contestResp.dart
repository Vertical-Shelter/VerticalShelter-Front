import 'package:app/data/models/Contest/phaseResp.dart';
import 'package:app/data/models/Contest/userContestReq.dart';
import 'package:app/data/models/Contest/userContestResp.dart';

class ContestResp {
  String? id;
  String? title;
  String? description;
  DateTime? date;
  int? duration;
  int? priceA;
  int? priceE;
  String? imageUrl;
  List<BlocResp>? blocs;
  String? qrCodeUrl;
  bool? isSubscribed;
  bool? qrCodeScanned;
  int? etat;
  List<UserContestResp> inscription = [];
  List<PhaseResp> phases = [];
  ContestResp({
    this.duration,
    this.etat,
    this.priceA,
    this.priceE,
    this.qrCodeUrl,
    this.id,
    this.title,
    this.qrCodeScanned,
    this.description,
    this.imageUrl,
    this.blocs,
    this.phases = const [],
    this.inscription = const [],
    this.isSubscribed,
    this.date,
  });
}

ContestResp contestRespFromJson(Map<String, dynamic> json) {
  return ContestResp(
    id: json['id'],
    priceA: json['priceA'] != null ? json['priceA']!.toInt() : null,
    priceE: json['priceE'] != null ? json['priceE']!.toInt() : null,
    isSubscribed: json['isSubscribed'],
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    duration: json['duration'],
    title: json['title'],
    etat: json['etat'],
    qrCodeScanned: json['qrCodeScanned'],
    description: json['description'],
    qrCodeUrl: json['qrCode_url'],
    imageUrl: json['image_url'],
    phases: json['phases'] != null
        ? List<PhaseResp>.from(
            json['phases'].map((x) => phaseRespFromJson(x)).toList())
        : [],
    inscription: json['inscriptionList'] != null
        ? List<UserContestResp>.from(
            json['inscriptionList'].map((x) => userContestRespFromJson(x)))
        : [],
    blocs: json['blocs'] != null
        ? List<BlocResp>.from(json['blocs'].map((x) =>
            BlocResp(numero: x['numero'], zones: x['zones'], id: x['id'])))
        : null,
  );
}

class BlocResp {
  int? numero;
  int? zones;
  String? id;

  BlocResp({
    this.numero,
    this.zones,
    this.id,
  });
}
