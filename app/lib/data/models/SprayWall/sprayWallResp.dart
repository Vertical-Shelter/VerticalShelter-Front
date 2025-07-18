import 'package:app/data/models/Annotation/Annotation.dart';

class SprayWallResp {
  String? id;
  String? climbingLocation_id;
  String? image;
  List<Annotation> annotations;
  String? name;

  SprayWallResp(
      {this.id,
      this.climbingLocation_id,
      this.image,
      this.name,
      required this.annotations});
}

SprayWallResp SpraywallRespFromJson(Map<String, dynamic> json) {
  // if (json['id'] == null) return (SprayWallResp());

  List<Annotation>? listannotations = [];
  if (json["annotations"] != null) {
    for (var item in json["annotations"]) {
      listannotations.add(AnnotationfromJson(item));
    }
  }

  return SprayWallResp(
    id: json['id'],
    climbingLocation_id: json['climbingLocation_id'],
    image: json['image'],
    name: json['label'],
    annotations: listannotations,
  );
}
