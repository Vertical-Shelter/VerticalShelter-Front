class PostNewPasswordResp {
  String? message;
  String? passwordError;
  String? confirmPasswordError;
  String? emailError;
  PostNewPasswordResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json.containsKey('password')) {
      if (json['password'] is List) {
        String listStr = '';
        json['password'].forEach((str) => listStr += str + ' ');
        passwordError = listStr;
      } else
        passwordError = json['password'];
    }
    if (json.containsKey('email')) {
      if (json['email'] is List) {
        String listStr = '';
        json['email'].forEach((str) => listStr += str + ' ');
        emailError = listStr;
      } else
        emailError = json['email'];
    }
    if (json.containsKey('confirmPassword')) {
      if (json['confirmPassword'] is List) {
        String listStr = '';
        json['confirmPassword'].forEach((str) => listStr += str + ' ');
        confirmPasswordError = listStr;
      } else
        confirmPasswordError = json['confirmPassword'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}
