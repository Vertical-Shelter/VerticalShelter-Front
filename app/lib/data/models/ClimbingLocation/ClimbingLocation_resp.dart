import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/models/Secteur/secteurResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';

ClimbingLocationResp climbingLocationrespFromJson(Map<String, dynamic> json) {
  List<GradeResp> gradeSystems = [];
  if (json['grades'] != null) {
    List Jsoncolors = json['grades'];
    for (var color in Jsoncolors) {
      gradeSystems.add(gradeRespfromJson(color)!);
    }
  }

  List<SecteurResp> secteurs = [];
  if (json['secteurs'] != null) {
    List Jsonsecteurs = json['secteurs'];

    for (var secteur in Jsonsecteurs) {
      secteurs.add(secteurRespFromJson(secteur));
    }
  }

  return ClimbingLocationResp(
    attributes:
        json['attributes'] == null ? [] : List<String>.from(json['attributes']),
    ouvreurNames: json['ouvreurNames'] == null
        ? []
        : List<String>.from(json['ouvreurNames']),
    newSector: json['listNewLabel'] == null
        ? []
        : [for (var sector in json['listNewLabel']) sector.toString()],
    nextClosedSector: json['listNextSector'] == null
        ? []
        : [for (var sector in json['listNextSector']) sector.toString()],
    id: json['id'] ?? '',
    address: json['address'],
    new_topo_url: json['new_topo_url'] ?? '',
    city: json['city'] ?? '',
    topo: json['topo_url'] ?? '',
    country: json['country'] ?? '',
    actualContest: json['actual_contest'] == null
        ? null
        : contestRespFromJson(json['actual_contest']),
    name: json['name'] ?? '',
    image: json['image_url'] ?? '',
    gradeSystem: gradeSystems,
    secteurs: secteurs,
    isPartnership: json['isPartnership'] ?? false,
    holds_color: json['holds_color'] == null
        ? []
        : List<String>.from(json['holds_color']),
  );
}

class ClimbingLocationResp {
  String id;
  ContestResp? actualContest;
  String name;
  String? address;
  String city;
  String country;
  String image;
  String topo;
  String new_topo_url;
  List<SecteurResp>? secteurs;
  List<GradeResp>? gradeSystem;
  List<String> nextClosedSector;
  List<String> holds_color;
  List<String> newSector;
  List<String> ouvreurNames;
  List<String> attributes;
  bool isPartnership = false;

  // ClimbingLocationMinimalResp toMinimal() {
  //   return ClimbingLocationMinimalResp(
  //     gradeSystem: gradeSystem,
  //     id: id,
  //     name: name,
  //     city: city,
  //     country: country,
  //     image: image,
  //   );
  // }

  ClimbingLocationResp({
    required this.secteurs,
    required this.id,
    required this.name,
    required this.newSector,
    required this.ouvreurNames,
    this.address,
    required this.attributes,
    required this.city,
    this.isPartnership = false,
    required this.country,
    this.actualContest,
    required this.topo,
    this.holds_color = const [],
    required this.new_topo_url,
    required this.image,
    required this.nextClosedSector,
    this.gradeSystem = const [],
  });
}

ClimbingLocationMinimalResp climbingLocationMinimalrespFromJson(
    Map<String, dynamic> json) {
  List<GradeResp> gradeSystems = [];
  if (json['grades'] != null) {
    List Jsoncolors = json['grades'];

    for (var color in Jsoncolors) {
      gradeSystems.add(gradeRespfromJson(color)!);
    }
  }
  return ClimbingLocationMinimalResp(
    id: json['id'],
    name: json['name'],
    city: json['city'],
    country: json['country'],
    image: json['image_url'],
    gradeSystem: gradeSystems,
  );
}

class ClimbingLocationMinimalResp {
  String id;
  String name;
  String? image;
  String city;
  String country;
  List<GradeResp> gradeSystem;

  ClimbingLocationMinimalResp({
    required this.id,
    required this.name,
    required this.image,
    required this.city,
    required this.country,
    required this.gradeSystem,
  });
}
