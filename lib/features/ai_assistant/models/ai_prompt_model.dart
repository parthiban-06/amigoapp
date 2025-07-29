import 'dart:convert';

class AiPromptModel {
  final int id;
  final String prompt;
  final String desc;

  AiPromptModel({
    required this.prompt,
    required this.id,
    required this.desc,
  });

  // Factory constructor to create a PromptCard from JSON
  factory AiPromptModel.fromJson(Map<String, dynamic> json) {
    return AiPromptModel(
      prompt: json['prompt'] as String,
      id: json['id'] as int,
      desc: json['desc'] as String,
    );
  }

  // Method to convert PromptCard to JSON
  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'id': id,
      'desc': desc,
    };
  }
}

// Extension method to parse a list of PromptCards from JSON
extension PromptCardListParser on List {
  List<AiPromptModel> toPromptCards() {
    return map((item) => AiPromptModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

// Example usage for parsing the JSON
List<AiPromptModel> parsePromptCards(String jsonString) {
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((item) => AiPromptModel.fromJson(item)).toList();
}

List<AiPromptModel> promptsFromJsonList(List<dynamic> data) {
  return List<AiPromptModel>.from(
      data.map((item) => AiPromptModel.fromJson(item)));
}
