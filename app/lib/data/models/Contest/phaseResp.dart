class PhaseResp {
  String? duree;
  String? startTime;
  int numero;
  String? id;

  PhaseResp({
    required this.id,
    required this.duree,
    required this.startTime,
    required this.numero,
  });
}

PhaseResp phaseRespFromJson(Map<String, dynamic> json) {
  return PhaseResp(
    duree: json['duree'],
    id: json['id'],
    startTime: json['startTime'],
    numero: json['numero'],
  );
}
