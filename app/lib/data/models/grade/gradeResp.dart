class GradeResp {
  final String id;
  final String ref1;
  final String? ref2;
  final int vgrade;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeResp && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  GradeResp({
    required this.id,
    required this.ref1,
    required this.ref2,
    required this.vgrade,
  }) {}

  factory GradeResp.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null as GradeResp;
    }

    return GradeResp(
      id: json['id'],
      ref1: json['ref1'],
      ref2: json['ref2'],
      vgrade: json['vgrade'],
    );
  }
}

GradeResp? gradeRespfromJson(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }

  return GradeResp(
    id: json['id'],
    ref1: json['ref1'],
    ref2: json['ref2'],
    vgrade: json['vgrade'].round(),
  );
}
