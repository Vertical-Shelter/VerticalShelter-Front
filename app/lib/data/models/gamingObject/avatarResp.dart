import 'package:app/core/app_export.dart';

class AvatarResp {
  String? id;
  String? name;
  String? description;
  String? image;
  int price = 0;
  bool isBought;
  bool isEquiped = false;

  AvatarResp({
    this.id,
    this.isEquiped = false,
    this.name,
    this.isBought = false,
    this.description,
    this.image,
    this.price = 0,
  });
}

AvatarResp avatarRespFromJson(Map<String, dynamic> json) {
  if (json['detail'] != null) {
    throw Exception(json['detail']);
  }
  return AvatarResp(
    id: json['id'],
    name: json['name'],
    isEquiped: json['isEquiped'] ?? false,
    isBought: json['isBought'] ?? false,
    description: json['description'],
    image: json['avatar_url'] ?? json['image_url'],
    price: json['price'] is int ? json['price'] : json['price'].toInt(),
  );
}
