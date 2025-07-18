class UserVSLResp {
  String id;
  String? username;
  int? points;
  String? profile_image_url;

  UserVSLResp({
    required this.id,
    this.username,
    this.points,
    this.profile_image_url,
  });
}

UserVSLResp UserVSLRespFromJson(Map<String, dynamic> json) {
  return UserVSLResp(
    id: json['id'] as String,
    username: json['username'] as String?, // Facultatif
    points: json['points'] as int?, // Facultatif
    profile_image_url: json['profile_image_url'] as String?, // Facultatif
  );
}
