QuestResp questRespFromJson(Map<String, dynamic> json) {
  return QuestResp(
    title: json['title'],
    description: json['description'],
    image: json['image_url'],
    xp: json['xp'],
    quota: json['quota'],
    type: json['type'],
    id: json['id'],
  );
}

class QuestResp {
  final String? title;
  final String? description;
  final String? image;
  final int? xp;
  final int? quota;
  final String? type;
  final String? id;

  QuestResp({
    required this.title,
    required this.description,
    required this.image,
    required this.xp,
    required this.quota,
    required this.type,
    this.id,
  });
}

