import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_prompt_model.dart';

void main() {
  group('AiPromptModel', () {
    final jsonMap = {
      'prompt': 'What is your name?',
      'id': 1,
      'desc': 'Ask for name',
    };

    test('fromJson parses all fields', () {
      final model = AiPromptModel.fromJson(jsonMap);
      expect(model.prompt, 'What is your name?');
      expect(model.id, 1);
      expect(model.desc, 'Ask for name');
    });

    test('toJson returns correct map', () {
      final model = AiPromptModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['prompt'], 'What is your name?');
      expect(map['id'], 1);
      expect(map['desc'], 'Ask for name');
    });
  });

  group('PromptCardListParser extension', () {
    test('toPromptCards parses list of maps', () {
      final list = [
        {'prompt': 'A', 'id': 1, 'desc': 'D1'},
        {'prompt': 'B', 'id': 2, 'desc': 'D2'},
      ];
      final cards = list.toPromptCards();
      expect(cards.length, 2);
      expect(cards[0].prompt, 'A');
      expect(cards[1].desc, 'D2');
    });
  });

  group('parsePromptCards', () {
    test('parses from JSON string', () {
      final jsonString = '[{"prompt":"P1","id":10,"desc":"D1"}]';
      final cards = parsePromptCards(jsonString);
      expect(cards.length, 1);
      expect(cards[0].prompt, 'P1');
      expect(cards[0].id, 10);
      expect(cards[0].desc, 'D1');
    });
  });

  group('promptsFromJsonList', () {
    test('parses from list', () {
      final list = [
        {'prompt': 'X', 'id': 5, 'desc': 'DX'},
        {'prompt': 'Y', 'id': 6, 'desc': 'DY'},
      ];
      final models = promptsFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].prompt, 'X');
      expect(models[1].id, 6);
    });
  });
}
