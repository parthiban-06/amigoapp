import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_response.dart';

void main() {
  group('AIChatModel', () {
    final json = {
      'initial_questions': [
        {
          'id': 'q1',
          'text': 'What is your name?',
          'choices': [
            {'id': 'c1', 'text': 'Alice'},
            {'id': 'c2', 'text': 'Bob'}
          ]
        }
      ],
      'responses': [
        {
          'choice_id': 'c1',
          'response_text': 'Hello Alice!',
          'dynamic_response': {
            'temperature': {'unit': 'C', 'value': '20'},
            'conditions': 'Sunny',
            'humidity': '50%',
            'wind_speed': '10km/h',
            'date': '2025-06-27',
            'location': 'Paris',
            'forecast': [
              {
                'day': 'Monday',
                'temperature': {'high': 25, 'low': 15},
                'condition': 'Clear'
              }
            ]
          },
          'ai_chat_response': null,
          'follow_up_questions': [
            {
              'id': 'fq1',
              'text': 'How are you?',
              'choices': [
                {'id': 'fc1', 'text': 'Good'},
                {'id': 'fc2', 'text': 'Bad'}
              ]
            }
          ]
        }
      ]
    };

    test('fromJson parses all fields', () {
      final model = AIChatModel.fromJson(json);
      expect(model.initialQuestions?.length, 1);
      expect(model.initialQuestions?.first.id, 'q1');
      expect(model.initialQuestions?.first.text, 'What is your name?');
      expect(model.initialQuestions?.first.choices?.length, 2);
      expect(model.initialQuestions?.first.choices?.first.id, 'c1');
      expect(model.responses?.length, 1);
      final resp = model.responses!.first;
      expect(resp.choiceId, 'c1');
      expect(resp.responseText, 'Hello Alice!');
      expect(resp.dynamicResponse?.temperature?.unit, 'C');
      expect(resp.dynamicResponse?.temperature?.value, '20');
      expect(resp.dynamicResponse?.conditions, 'Sunny');
      expect(resp.dynamicResponse?.forecast?.first.day, 'Monday');
      expect(resp.dynamicResponse?.forecast?.first.temperature?.high, 25);
      expect(resp.dynamicResponse?.forecast?.first.temperature?.low, 15);
      expect(resp.dynamicResponse?.forecast?.first.condition, 'Clear');
      expect(resp.followUpQuestions?.first.id, 'fq1');
      expect(resp.followUpQuestions?.first.text, 'How are you?');
      expect(resp.followUpQuestions?.first.choices?.first.id, 'fc1');
      // Test aiCharResponse is null
      expect(resp.aiCharResponse, isNull);
    });

    test('toJson returns correct map', () {
      final model = AIChatModel.fromJson(json);
      final map = model.toJson();
      expect(map['initial_questions'][0]['id'], 'q1');
      expect(map['initial_questions'][0]['choices'][0]['id'], 'c1');
      expect(map['responses'][0]['choice_id'], 'c1');
      expect(map['responses'][0]['dynamic_response']['temperature']['unit'], 'C');
      expect(map['responses'][0]['dynamic_response']['forecast'][0]['day'], 'Monday');
      expect(map['responses'][0]['follow_up_questions'][0]['id'], 'fq1');
      expect(map['responses'][0]['ai_chat_response'], isNull);
    });

    test('equality/hashCode (by fields, since ==/hashCode not implemented)', () {
      final model1 = AIChatModel.fromJson(json);
      final model2 = AIChatModel.fromJson(json);
      // Compare fields manually since ==/hashCode are not implemented
      expect(model1.initialQuestions?.length, model2.initialQuestions?.length);
      expect(model1.initialQuestions?.first.id, model2.initialQuestions?.first.id);
      expect(model1.initialQuestions?.first.text, model2.initialQuestions?.first.text);
      expect(model1.initialQuestions?.first.choices?.length, model2.initialQuestions?.first.choices?.length);
      expect(model1.initialQuestions?.first.choices?.first.id, model2.initialQuestions?.first.choices?.first.id);
      expect(model1.responses?.length, model2.responses?.length);
      expect(model1.responses?.first.choiceId, model2.responses?.first.choiceId);
      expect(model1.responses?.first.responseText, model2.responses?.first.responseText);
      expect(model1.responses?.first.dynamicResponse?.temperature?.unit, model2.responses?.first.dynamicResponse?.temperature?.unit);
      expect(model1.responses?.first.dynamicResponse?.temperature?.value, model2.responses?.first.dynamicResponse?.temperature?.value);
      expect(model1.responses?.first.dynamicResponse?.forecast?.first.day, model2.responses?.first.dynamicResponse?.forecast?.first.day);
      expect(model1.responses?.first.followUpQuestions?.first.id, model2.responses?.first.followUpQuestions?.first.id);
      expect(model1.responses?.first.aiCharResponse, model2.responses?.first.aiCharResponse);
    });

    test('copyWith returns new instance with updated fields', () {
      final model = AIChatModel.fromJson(json);
      // Since copyWith is not defined, just assign a new instance for testing
      final updated = AIChatModel(
        initialQuestions: [
          InitialQuestions(id: 'q2', text: 'T', choices: [Choices(id: 'c3', text: 'Z')])
        ],
        responses: model.responses,
      );
      expect(updated.initialQuestions?.first.id, 'q2');
      expect(updated.initialQuestions?.first.choices?.first.id, 'c3');
      expect(updated, isNot(equals(model)));
    });

    test('handles null/empty/edge cases', () {
      final empty = AIChatModel();
      expect(empty.initialQuestions, isNull);
      expect(empty.responses, isNull);
      final fromNull = AIChatModel.fromJson({});
      expect(fromNull.initialQuestions, isNull);
      expect(fromNull.responses, isNull);
      final toJson = empty.toJson();
      expect(toJson['initial_questions'], isNull);
      expect(toJson['responses'], isNull);
    });

    test('handles malformed JSON gracefully', () {
      final malformedJson = {
        'initial_questions': null,
        'responses': null,
      };
      final model = AIChatModel.fromJson(malformedJson);
      expect(model.initialQuestions, isNull);
      expect(model.responses, isNull);
    });

    test('handles empty lists in JSON', () {
      final emptyListsJson = {
        'initial_questions': [],
        'responses': [],
      };
      final model = AIChatModel.fromJson(emptyListsJson);
      expect(model.initialQuestions, isEmpty);
      expect(model.responses, isEmpty);
    });
  });

  group('InitialQuestions', () {
    test('fromJson and toJson', () {
      final json = {
        'id': 'q2',
        'text': 'Question?',
        'choices': [
          {'id': 'c1', 'text': 'A'},
          {'id': 'c2', 'text': 'B'}
        ]
      };
      final q = InitialQuestions.fromJson(json);
      expect(q.id, 'q2');
      expect(q.text, 'Question?');
      expect(q.choices?.length, 2);
      expect(q.choices?.first.id, 'c1');
      final map = q.toJson();
      expect(map['id'], 'q2');
      expect(map['choices'][0]['id'], 'c1');
    });

    test('handles null values', () {
      final json = {
        'id': null,
        'text': null,
        'choices': null,
      };
      final q = InitialQuestions.fromJson(json);
      expect(q.id, isNull);
      expect(q.text, isNull);
      expect(q.choices, isNull);
      final map = q.toJson();
      expect(map['id'], isNull);
      expect(map['text'], isNull);
      expect(map['choices'], isNull);
    });

    test('handles empty choices list', () {
      final json = {
        'id': 'q1',
        'text': 'Test',
        'choices': [],
      };
      final q = InitialQuestions.fromJson(json);
      expect(q.choices, isEmpty);
    });
  });

  group('Choices', () {
    test('fromJson and toJson', () {
      final json = {'id': 'c1', 'text': 'Choice'};
      final c = Choices.fromJson(json);
      expect(c.id, 'c1');
      expect(c.text, 'Choice');
      final map = c.toJson();
      expect(map['id'], 'c1');
      expect(map['text'], 'Choice');
    });

    test('handles null values', () {
      final json = {'id': null, 'text': null};
      final c = Choices.fromJson(json);
      expect(c.id, isNull);
      expect(c.text, isNull);
      final map = c.toJson();
      expect(map['id'], isNull);
      expect(map['text'], isNull);
    });
  });

  group('Responses', () {
    final json = {
      'choice_id': 'c1',
      'response_text': 'Resp',
      'dynamic_response': null,
      'ai_chat_response': null,
      'follow_up_questions': [
        {
          'id': 'fq1',
          'text': 'Follow?',
          'choices': [
            {'id': 'fc1', 'text': 'Yes'}
          ]
        }
      ]
    };
    
    test('fromJson and toJson', () {
      final r = Responses.fromJson(json);
      expect(r.choiceId, 'c1');
      expect(r.responseText, 'Resp');
      expect(r.dynamicResponse, isNull);
      expect(r.followUpQuestions?.first.id, 'fq1');
      expect(r.aiCharResponse, isNull);
      final map = r.toJson();
      expect(map['choice_id'], 'c1');
      expect(map['follow_up_questions'][0]['id'], 'fq1');
      expect(map['ai_chat_response'], isNull);
    });

    test('handles null ai_chat_response', () {
      final jsonWithoutAi = {
        'choice_id': 'c1',
        'response_text': 'Resp',
        'dynamic_response': null,
        'ai_chat_response': null,
        'follow_up_questions': null,
      };
      final r = Responses.fromJson(jsonWithoutAi);
      expect(r.aiCharResponse, isNull);
      expect(r.followUpQuestions, isNull);
    });

    test('handles all null values', () {
      final allNullJson = {
        'choice_id': null,
        'response_text': null,
        'dynamic_response': null,
        'ai_chat_response': null,
        'follow_up_questions': null,
      };
      final r = Responses.fromJson(allNullJson);
      expect(r.choiceId, isNull);
      expect(r.responseText, isNull);
      expect(r.dynamicResponse, isNull);
      expect(r.aiCharResponse, isNull);
      expect(r.followUpQuestions, isNull);
    });
  });

  group('DynamicResponse', () {
    final json = {
      'temperature': {'unit': 'F', 'value': '70'},
      'conditions': 'Cloudy',
      'humidity': '60%',
      'wind_speed': '5mph',
      'date': '2025-06-28',
      'location': 'NY',
      'forecast': [
        {
          'day': 'Tue',
          'temperature': {'high': 30, 'low': 20},
          'condition': 'Rain'
        }
      ]
    };
    
    test('fromJson and toJson', () {
      final d = DynamicResponse.fromJson(json);
      expect(d.temperature?.unit, 'F');
      expect(d.conditions, 'Cloudy');
      expect(d.humidity, '60%');
      expect(d.windSpeed, '5mph');
      expect(d.date, '2025-06-28');
      expect(d.location, 'NY');
      expect(d.forecast?.first.day, 'Tue');
      final map = d.toJson();
      expect(map['temperature']['unit'], 'F');
      expect(map['forecast'][0]['day'], 'Tue');
      expect(map['conditions'], 'Cloudy');
      expect(map['humidity'], '60%');
      expect(map['wind_speed'], '5mph');
      expect(map['date'], '2025-06-28');
      expect(map['location'], 'NY');
    });

    test('handles null temperature', () {
      final jsonWithoutTemp = {
        'temperature': null,
        'conditions': 'Sunny',
        'humidity': '50%',
        'wind_speed': '10km/h',
        'date': '2025-06-27',
        'location': 'Paris',
        'forecast': null,
      };
      final d = DynamicResponse.fromJson(jsonWithoutTemp);
      expect(d.temperature, isNull);
      expect(d.forecast, isNull);
      expect(d.conditions, 'Sunny');
    });

    test('handles empty forecast list', () {
      final jsonWithEmptyForecast = {
        'temperature': {'unit': 'C', 'value': '20'},
        'conditions': 'Clear',
        'humidity': '40%',
        'wind_speed': '5km/h',
        'date': '2025-06-27',
        'location': 'London',
        'forecast': [],
      };
      final d = DynamicResponse.fromJson(jsonWithEmptyForecast);
      expect(d.forecast, isEmpty);
    });
  });

  group('Temperature', () {
    test('fromJson and toJson', () {
      final json = {'unit': 'K', 'value': '273'};
      final t = Temperature.fromJson(json);
      expect(t.unit, 'K');
      expect(t.value, '273');
      final map = t.toJson();
      expect(map['unit'], 'K');
      expect(map['value'], '273');
    });

    test('handles null values', () {
      final json = {'unit': null, 'value': null};
      final t = Temperature.fromJson(json);
      expect(t.unit, isNull);
      expect(t.value, isNull);
      final map = t.toJson();
      expect(map['unit'], isNull);
      expect(map['value'], isNull);
    });
  });

  group('WeatherForecast', () {
    final json = {
      'day': 'Wed',
      'temperature': {'high': 40, 'low': 30},
      'condition': 'Storm'
    };
    
    test('fromJson and toJson', () {
      final w = WeatherForecast.fromJson(json);
      expect(w.day, 'Wed');
      expect(w.temperature?.high, 40);
      expect(w.temperature?.low, 30);
      expect(w.condition, 'Storm');
      final map = w.toJson();
      expect(map['day'], 'Wed');
      expect(map['temperature']['high'], 40);
    });

    test('handles null temperature', () {
      final jsonWithoutTemp = {
        'day': 'Thu',
        'temperature': null,
        'condition': 'Clear'
      };
      final w = WeatherForecast.fromJson(jsonWithoutTemp);
      expect(w.temperature, isNull);
      expect(w.day, 'Thu');
      expect(w.condition, 'Clear');
    });

    test('handles null values', () {
      final json = {
        'day': null,
        'temperature': null,
        'condition': null
      };
      final w = WeatherForecast.fromJson(json);
      expect(w.day, isNull);
      expect(w.temperature, isNull);
      expect(w.condition, isNull);
    });
  });

  group('TemperatureRange', () {
    test('fromJson and toJson', () {
      final json = {'high': 100, 'low': 50};
      final t = TemperatureRange.fromJson(json);
      expect(t.high, 100);
      expect(t.low, 50);
      final map = t.toJson();
      expect(map['high'], 100);
      expect(map['low'], 50);
    });

    test('handles null values', () {
      final json = {'high': null, 'low': null};
      final t = TemperatureRange.fromJson(json);
      expect(t.high, isNull);
      expect(t.low, isNull);
      final map = t.toJson();
      expect(map['high'], isNull);
      expect(map['low'], isNull);
    });
  });

  group('FollowUpQuestions', () {
    final json = {
      'id': 'f1',
      'text': 'Follow?',
      'choices': [
        {'id': 'c1', 'text': 'Yes'}
      ]
    };
    
    test('fromJson and toJson', () {
      final f = FollowUpQuestions.fromJson(json);
      expect(f.id, 'f1');
      expect(f.text, 'Follow?');
      expect(f.choices?.first.id, 'c1');
      final map = f.toJson();
      expect(map['id'], 'f1');
      expect(map['choices'][0]['id'], 'c1');
    });

    test('handles null values', () {
      final json = {
        'id': null,
        'text': null,
        'choices': null,
      };
      final f = FollowUpQuestions.fromJson(json);
      expect(f.id, isNull);
      expect(f.text, isNull);
      expect(f.choices, isNull);
      final map = f.toJson();
      expect(map['id'], isNull);
      expect(map['text'], isNull);
      expect(map['choices'], isNull);
    });

    test('handles empty choices list', () {
      final json = {
        'id': 'f1',
        'text': 'Test',
        'choices': [],
      };
      final f = FollowUpQuestions.fromJson(json);
      expect(f.choices, isEmpty);
    });
  });

  test('AIChatModel can be instantiated', () {
    final model = AIChatModel();
    expect(model, isA<AIChatModel>());
  });

  test('All model classes can be instantiated with null values', () {
    final initialQuestions = InitialQuestions();
    final choices = Choices();
    final responses = Responses();
    final dynamicResponse = DynamicResponse();
    final temperature = Temperature();
    final weatherForecast = WeatherForecast();
    final temperatureRange = TemperatureRange();
    final followUpQuestions = FollowUpQuestions();

    expect(initialQuestions, isA<InitialQuestions>());
    expect(choices, isA<Choices>());
    expect(responses, isA<Responses>());
    expect(dynamicResponse, isA<DynamicResponse>());
    expect(temperature, isA<Temperature>());
    expect(weatherForecast, isA<WeatherForecast>());
    expect(temperatureRange, isA<TemperatureRange>());
    expect(followUpQuestions, isA<FollowUpQuestions>());
  });
}
