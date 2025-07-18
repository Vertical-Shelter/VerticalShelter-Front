import 'package:app/data/models/SeasonPass/ProductResp.dart';

LevelResp levelRespFromJson(Map<String, dynamic> json) {
  return LevelResp(
    numero: json['numero'],
    xp: json['xp'],
    recompense_G: json['recompense_G'] != null
        ? productRespFromJson(json['recompense_G'])
        : null,
    recompense_P: json['recompense_P'] != null
        ? productRespFromJson(json['recompense_P'])
        : null, 
    id: json['id'],
    isPremiumUnlock: json['is_Premium_unlock'],
    isFreeUnlock: json['is_Free_unlock'],
    isPremiumClaimed: json['isPremiumClaimed'],
    isFreeClaimed: json['isFreeClaimed'],
    freePromotion: json['free_Promotion'],
    premiumPromotion: json['premium_Promotion'], 
  );
}

class LevelResp {
  final int? numero;
  final int? xp;
  final ProductResp? recompense_G;
  final ProductResp? recompense_P;
  final String? id;
  final bool? isPremiumUnlock;
  final bool? isFreeUnlock;
  bool? isPremiumClaimed;
  bool? isFreeClaimed;
  final String? freePromotion;
  final String? premiumPromotion;

  LevelResp({
    this.numero,
    this.xp,
    this.recompense_G,
    this.recompense_P,
    this.id,
    this.isPremiumUnlock,
    this.isFreeUnlock,
    this.isPremiumClaimed,
    this.isFreeClaimed,
    this.freePromotion,
    this.premiumPromotion
  });
}
