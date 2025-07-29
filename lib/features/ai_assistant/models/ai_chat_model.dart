import 'package:visaamigo/features/ai_assistant/models/ai_chat_response.dart';

class AIChatModel {
  final List<InitialQuestions>? initialQuestions;
  final List<Responses>? responses;

  AIChatModel({
    this.initialQuestions,
    this.responses,
  });

  factory AIChatModel.fromJson(Map<String, dynamic> json) {
    return AIChatModel(
      initialQuestions: (json['initial_questions'] as List?)
          ?.map((e) => InitialQuestions.fromJson(e))
          .toList(),
      responses: (json['responses'] as List?)
          ?.map((e) => Responses.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'initial_questions': initialQuestions?.map((e) => e.toJson()).toList(),
      'responses': responses?.map((e) => e.toJson()).toList(),
    };
  }
}

class InitialQuestions {
  final String? id;
  final String? text;
  final List<Choices>? choices;

  InitialQuestions({
    this.id,
    this.text,
    this.choices,
  });

  factory InitialQuestions.fromJson(Map<String, dynamic> json) {
    return InitialQuestions(
      id: json['id'],
      text: json['text'],
      choices:
          (json['choices'] as List?)?.map((e) => Choices.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'choices': choices?.map((e) => e.toJson()).toList(),
    };
  }
}

class Choices {
  final String? id;
  final String? text;

  Choices({this.id, this.text});

  factory Choices.fromJson(Map<String, dynamic> json) {
    return Choices(
      id: json['id'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }
}

class Responses {
  final String? choiceId;
  final String? responseText;
  final DynamicResponse? dynamicResponse;
  final AiChatResponse? aiCharResponse;
  final List<FollowUpQuestions>? followUpQuestions;

  Responses({
    this.choiceId,
    this.responseText,
    this.dynamicResponse,
    this.aiCharResponse,
    this.followUpQuestions,
  });

  factory Responses.fromJson(Map<String, dynamic> json) {
    return Responses(
      choiceId: json['choice_id'],
      responseText: json['response_text'],
      dynamicResponse: json['dynamic_response'] != null
          ? DynamicResponse.fromJson(json['dynamic_response'])
          : null,
      aiCharResponse: json['ai_chat_response'] != null
          ? AiChatResponse.fromJson(json['ai_chat_response'])
          : null,
      followUpQuestions: (json['follow_up_questions'] as List?)
          ?.map((e) => FollowUpQuestions.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'choice_id': choiceId,
      'response_text': responseText,
      'dynamic_response': dynamicResponse?.toJson(),
      'ai_chat_response': aiCharResponse?.toJson(),
      'follow_up_questions': followUpQuestions?.map((e) => e.toJson()).toList(),
    };
  }
}

class DynamicResponse {
  final Temperature? temperature;
  final String? conditions;
  final String? humidity;
  final String? windSpeed;
  final String? date;
  final String? location;
  final List<WeatherForecast>? forecast;

  DynamicResponse({
    this.temperature,
    this.conditions,
    this.humidity,
    this.windSpeed,
    this.date,
    this.location,
    this.forecast,
  });

  factory DynamicResponse.fromJson(Map<String, dynamic> json) {
    return DynamicResponse(
      temperature: json['temperature'] != null
          ? Temperature.fromJson(json['temperature'])
          : null,
      conditions: json['conditions'],
      humidity: json['humidity'],
      windSpeed: json['wind_speed'],
      date: json['date'],
      location: json['location'],
      forecast: (json['forecast'] as List?)
          ?.map((e) => WeatherForecast.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature?.toJson(),
      'conditions': conditions,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'date': date,
      'location': location,
      'forecast': forecast?.map((e) => e.toJson()).toList(),
    };
  }
}

class Temperature {
  final String? unit;
  final String? value;

  Temperature({this.unit, this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      unit: json['unit'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'unit': unit, 'value': value};
  }
}

class WeatherForecast {
  final String? day;
  final TemperatureRange? temperature;
  final String? condition;

  WeatherForecast({
    this.day,
    this.temperature,
    this.condition,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      day: json['day'],
      temperature: json['temperature'] != null
          ? TemperatureRange.fromJson(json['temperature'])
          : null,
      condition: json['condition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'temperature': temperature?.toJson(),
      'condition': condition,
    };
  }
}

class TemperatureRange {
  final int? high;
  final int? low;

  TemperatureRange({this.high, this.low});

  factory TemperatureRange.fromJson(Map<String, dynamic> json) {
    return TemperatureRange(
      high: json['high'],
      low: json['low'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'high': high, 'low': low};
  }
}

class FollowUpQuestions {
  final String? id;
  final String? text;
  final List<Choices>? choices;

  FollowUpQuestions({
    this.id,
    this.text,
    this.choices,
  });

  factory FollowUpQuestions.fromJson(Map<String, dynamic> json) {
    return FollowUpQuestions(
      id: json['id'],
      text: json['text'],
      choices:
          (json['choices'] as List?)?.map((e) => Choices.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'choices': choices?.map((e) => e.toJson()).toList(),
    };
  }
}
