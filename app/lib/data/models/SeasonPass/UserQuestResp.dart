import 'package:app/data/models/SeasonPass/QuestResp.dart';

UserQuestResp userQuestRespFromJson(Map<String, dynamic> json) {
  return UserQuestResp(
    quest: json['queteId'] != null ? questRespFromJson(json['queteId']) : null,
    id: json['id'],
    progress: json['quota'],
    date: DateTime.parse(json['date']),
    isClaimed: json['is_claimed'],
    isClaimable: json['is_claimable'],
  );
}

class UserQuestResp {
  QuestResp? quest;
  String? id;
  int? progress;
  DateTime? date;
  bool? isClaimed;
  bool? isClaimable;

  UserQuestResp({
    this.quest,
    this.id,
    this.progress,
    this.date,
    this.isClaimed,
    this.isClaimable,
  });
}
