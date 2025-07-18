class SkillResp {
  final String? display_name;
  final int? level;
  final String? description;
  final int? xp_next_level;
  final int? xp_current_level;
  final String? icon;

  SkillResp(
      {this.display_name,
      this.level,
      this.description,
      this.xp_next_level,
      this.xp_current_level,
      this.icon});

  factory SkillResp.fromJson(Map<String, dynamic> json) {
    return SkillResp(
      display_name: json['display_name'],
      level: json['level'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SkillResp &&
        other.display_name == display_name &&
        other.level == level &&
        other.xp_next_level == xp_next_level &&
        other.xp_current_level == xp_current_level;
  }
}

SkillResp skillRespFromJson(Map<String, dynamic> json) {
  return SkillResp(
    display_name: json['display_name'],
    level: json['level'],
    description: json['description'],
    xp_next_level: json['xp_next_level'],
    xp_current_level: json['xp_current_level'],
    icon: json['icon'],
  );
}
