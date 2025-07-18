class ForgotPasswordResp {
  ForgotPasswordResp({
    this.message,
    this.error,
  });

  String? message;
  String? error;
}

ForgotPasswordResp forgotPasswordRespFromJson(Map<String, dynamic> json) {
  return ForgotPasswordResp(
    message: json['message'],
    error: json['detail'] == null ? null : json['detail']['email'],
  );
}
