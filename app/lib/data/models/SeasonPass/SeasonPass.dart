import 'package:app/data/models/SeasonPass/LevelResp.dart';

SeasonPassResp seasonPassRespFromJson(Map<String, dynamic> json) {
  if (json.isEmpty) return SeasonPassResp();
  return SeasonPassResp(
    title: json['title'],
    image_url: json['image_url'],
    description: json['description'],
    date_start: json['date_start'],
    date_end: json['date_end'],
    price: json['price'],
    is_active: json['is_active'],
    id: json['id'],
    levels: json['levels'] != null
        ? (json['levels'] as List).map((i) => levelRespFromJson(i)).toList()
        : null,
    level: json['level'],
    xp: json['xp'],
    isPremium: json['is_premium'],
    season: json['season'],
  );
}

class SeasonPassResp {
  final String? title;
  final String? image_url;
  final String? description;
  final String? date_start;
  final String? date_end;
  final double? price;
  final bool? is_active;
  final String? id;
  final List<LevelResp>? levels;
  final int? level;
  final int? xp;
  final bool isPremium;
  final String? season;

  SeasonPassResp({
    this.title,
    this.image_url,
    this.description,
    this.date_start,
    this.date_end,
    this.price,
    this.is_active,
    this.id,
    this.isPremium = false,
    this.levels,
    this.level,
    this.xp,
    this.season,
  });
}
