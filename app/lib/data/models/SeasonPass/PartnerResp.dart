import 'dart:convert';
import 'package:app/data/models/SeasonPass/ProductResp.dart';

PartnerResp partnerRespFromJson(Map<String, dynamic> json) {
  return PartnerResp(
    name: json['name'],
    description: json['description'],
    logo_url: json['logo_url'],
    website: json['website'],
    id: json['id'],
  );
}

class PartnerResp {
  final String? name;
  final String? description;
  final String? logo_url;
  final String? website;
  final String? id;

  PartnerResp({
    this.name,
    this.description,
    this.logo_url,
    this.website,
    this.id,
  });
}
