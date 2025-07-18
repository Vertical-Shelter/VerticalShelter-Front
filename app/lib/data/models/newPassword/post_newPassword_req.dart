class PostNewPasswordReq {
  String? email;
  String? password;
  String? confirmPassword;

  PostNewPasswordReq({this.email, this.password, this.confirmPassword});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.email != null) {
      data['email'] = this.email;
      data['password'] = this.password;
      data['confirmPassword'] = this.confirmPassword;
    }
    return data;
  }
}
