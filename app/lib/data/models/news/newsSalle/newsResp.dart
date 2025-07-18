class NewsResp {
  String? title;
  String? description;
  String? imageUrl;
  DateTime? date;
  String? id;
  String? link;
  bool? isRead = false;

  NewsResp({
    this.title,
    this.description,
    this.imageUrl,
    this.date,
    this.id,
    this.link,
    this.isRead,
  });
}

NewsResp newsRespFromJson(Map<String, dynamic> json) {
  return NewsResp(
    title: json['title'],
    id: json['id'],
    description: json['description'],
    imageUrl: json['image_url'],
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    link: json['link'],
    isRead: json['is_read'],
  );
}
