class PostCreateUserResp {
  String? email;
  String? password;

  PostCreateUserResp({this.email, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.email != null) {
      data['email'] = this.email;
    }
    if (this.password != null) {
      data['password'] = this.password;
    }
    return data;
  }
}

PostCreateUserResp createFromJson(Map<String, dynamic> json) {
  // Check if it is a error list or a simple string
  PostCreateUserResp postCreateUserResp = PostCreateUserResp();

  if (json.containsKey('detail')) {
    if (json['detail'] is Map) {
      if (json['detail'].containsKey('email')) {
        postCreateUserResp.email = json['detail']['email'];
      }
      if (json['detail'].containsKey('password')) {
        postCreateUserResp.password = json['detail']['password'];
      }
    }
  }
  return postCreateUserResp;
}
