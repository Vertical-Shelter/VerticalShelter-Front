import 'package:app/data/models/Annotation/Annotation.dart';
import 'package:app/data/models/SprayWall/sprayWallResp.dart';

class SecteurResp {
  final String id;
  // final String label;
  final String newlabel;
  final List<String> images;
  final List<Annotation> annotations;

  SecteurResp({
    required this.id,
    required this.annotations,
    // required this.label,
    required this.newlabel,
    required this.images,
  });

  SprayWallResp toSprayWallResp() {
    return SprayWallResp(
      id: id,
      name: newlabel,
      image: images.first,
      annotations: annotations,
    );
  }
}

SecteurResp secteurRespFromJson(Map<String, dynamic> json) {
  return SecteurResp(
    id: json['id'],
    // label: json['label'] ?? '',
    newlabel: json['newlabel'] ?? '',
    annotations: json['annotations'] == null
        ? []
        : List<Annotation>.from(
            json['annotations'].map((x) => AnnotationfromJson(x))),
    images: json['images'] == null ? [] : List<String>.from(json['images']),
  );
}
