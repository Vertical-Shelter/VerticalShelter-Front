class HoldResp {
  String id;
  int type;

  HoldResp(
      {required this.id,
      required this.type});
}

HoldResp HoldRespfromJson(Map<String, dynamic> item) {
  return HoldResp(
    id: item['id'],
    type: item['type'],
  );
}