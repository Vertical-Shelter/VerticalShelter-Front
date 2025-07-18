import 'package:dio/dio.dart';

class ClimbingLocationReq {
  List<String>? nextClosedSector;
  List<String>? ouvreurNames;
  List<String>? attributes;
  List<String>? holds_color;

  ClimbingLocationReq({
    this.nextClosedSector,
    this.ouvreurNames,
    this.holds_color,
    this.attributes,
  });

  Future<FormData> toFormData() async {
    var map = Map<String, dynamic>();
    if (ouvreurNames != null) {
      map['ouvreurNames'] = ouvreurNames;
    }
    if (holds_color != null) {
      map['holds_color'] = holds_color;
    }
    if (nextClosedSector != null) {
      map['newNextClosedSector'] = nextClosedSector;
    }
    if (attributes != null) {
      map['attributes'] = attributes;
    }
    var formData = FormData.fromMap(map, ListFormat.multi);
    return formData;
  }
}
