class SendOtpModel {
  final String email;
  final String preferredLanguage;

  SendOtpModel({
    required this.email,
    required this.preferredLanguage,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      email: json['email'],
      preferredLanguage: json['preferred_language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'preferred_language': preferredLanguage,
    };
  }
}
