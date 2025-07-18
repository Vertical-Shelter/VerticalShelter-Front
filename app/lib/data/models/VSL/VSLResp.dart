class VSLresp {
  final String? title;
  final String? description;
  final DateTime? start_date;
  final DateTime? end_date;
  final String? image_url;
  final String? id;
  final DateTime? inscription_start_date;

  VSLresp({
    required this.title,
    this.description,
    required this.start_date,
    required this.end_date,
    this.inscription_start_date,
    this.image_url,
    required this.id,
  });
}

VSLresp VSLRespFromJson(Map<String, dynamic> json) {
  return VSLresp(
    title: json['title'] as String,
    inscription_start_date:
    json['inscription_start_date'] == null ? null :
        DateTime.parse(json['inscription_start_date'] as String),
    description: json['description'] as String? ?? '',
    start_date: DateTime.parse(json['start_date'] as String),
    end_date: DateTime.parse(json['end_date'] as String),
    image_url: json['image_url'] as String? ?? '',
    id: json['id'] as String,
  );
}
