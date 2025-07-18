class BaniereResp {
  String? id;
  String? name;
  String? description;
  String? image;
  int price = 0;
  bool isBought;
  bool isEquiped = false;

  BaniereResp(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price = 0,
      this.isBought = false,
      this.isEquiped = false});
}

BaniereResp baniereRespFromJson(Map<String, dynamic> json) {
  if (json['detail'] != null) {
    throw Exception(json['detail']);
  }
  return BaniereResp(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    isBought: json['isBought'] ?? false,
    isEquiped: json['isEquiped'] ?? false,
    image: json['baniere_url'] ?? json['image_url'],
    price: json['price'] is int ? json['price'] : json['price'].toInt(),
  );
}
