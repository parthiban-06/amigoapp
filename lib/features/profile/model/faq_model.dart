import 'package:visaamigo/utils/utils.dart';

class FaqResponse {
  final int statusCode;
  final String messageKey;
  final List<FaqCategory> data;

  FaqResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: List<FaqCategory>.from(
        json['data'].map((x) => FaqCategory.fromJson(x)),
      ),
    );
  }
}

class FaqCategory {
  final String category;
  final List<Faq> faqs;

  FaqCategory({
    required this.category,
    required this.faqs,
  });

  factory FaqCategory.fromJson(Map<String, dynamic> json) {
    return FaqCategory(
      category: Utils.convrtStringUtf(json['category']),
      faqs: List<Faq>.from(
        json['faqs'].map((x) => Faq.fromJson(x)),
      ),
    );
  }
}

class Faq {
  final String questionText;
  final List<String> platforms;
  final List<String> validFor;
  final bool isActive;
  final String answerText;
  final bool secured;

  Faq({
    required this.questionText,
    required this.platforms,
    required this.validFor,
    required this.isActive,
    required this.answerText,
    required this.secured,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      questionText: Utils.convrtStringUtf(json['question_text']),
      platforms: List<String>.from(json['platforms']),
      validFor: List<String>.from(json['valid_for']),
      isActive: json['is_active'],
      answerText: Utils.convrtStringUtf(json['answer_text']),
      secured: json['secured'],
    );
  }
}
