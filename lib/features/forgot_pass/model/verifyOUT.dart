class VerifyOtpRequest {
  final String email;
  final String otp;
  final String password;

  VerifyOtpRequest({
    required this.email,
    required this.otp,
    required this.password,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequest(
      email: json['email'],
      otp: json['otp'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'password': password,
    };
  }
}
