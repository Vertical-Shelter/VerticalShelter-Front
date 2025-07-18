class PostLoginResp {
  String? access_token;
  String? userId;
  Map? error;
  String? climbingLocation;
  String? name;
  bool? isGym;
  String? picture;

  PostLoginResp(
      {this.access_token,
      this.userId,
      this.isGym,
      this.name,
      this.picture,
      this.error,
      this.climbingLocation});
}

PostLoginResp LoginRespfromJson(Map<String, dynamic> json) {
  if (json['detail'] != null) {
    return PostLoginResp(
      error: json['detail'],
    );
  }

  return PostLoginResp(
    isGym: json['isGym'],
    access_token: json['access_token'],
    userId: json['userId'],
    name: json['name'],
    picture: json['profile_image_url'],
    climbingLocation: json['climbingLocation'],
    error: json['error'],
  );
}
