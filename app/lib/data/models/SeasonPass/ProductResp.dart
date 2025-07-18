import 'package:app/data/models/SeasonPass/PartnerResp.dart';

ProductResp productRespFromJson(Map<String, dynamic> json) {
  return ProductResp(
    name: json['name'],
    description: json['description'],
    promotion: json['promotion'],
    code_promo: json['code_promo'],
    id: json['id'],
    recompense_type: json['recompense_type'],
    partner:
        json['partner'] != null ? partnerRespFromJson(json['partner']) : null,
    imageURL: json['image_url'],
    productURL: json['product_url'],
  );
}

class ProductResp {
  final String? name;
  final String? description;
  final String? promotion;
  final String? code_promo;
  final String? id;
  final PartnerResp? partner;
  final String? imageURL;
  final String? productURL;
  final String? recompense_type;

  ProductResp({
    required this.name,
    required this.description,
    required this.recompense_type,
    required this.promotion,
    required this.code_promo,
    required this.id,
    this.partner,
    this.imageURL,
    this.productURL,
  });
}
