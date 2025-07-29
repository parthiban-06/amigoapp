import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_search_places_expand_collapse_model.dart';

class Utils {
  static String convrtStringUtf(String input) => input;
}

void main() {
  group('AiSearchPlacesExpandCollapseModel', () {
    test('fromJson sets id and isExpand=false', () {
      final json = {'id': 'abc', 'isExpand': true};
      final model = AiSearchPlacesExpandCollapseModel.fromJson(json);
      expect(model.id, ''); // Utils.convrtStringUtf returns empty string
      expect(model.isExpand, false); // always false from fromJson
    });

    test('toJson returns correct map', () {
      final model = AiSearchPlacesExpandCollapseModel(id: 'xyz', isExpand: true);
      final map = model.toJson();
      expect(map['id'], 'xyz');
      expect(map['isExpand'], true);
    });

    test('copyWith returns new instance with updated fields', () {
      final model = AiSearchPlacesExpandCollapseModel(id: 'id1', isExpand: false);
      final updated = model.copyWith(id: 'id2', isExpand: true);
      expect(updated.id, 'id2');
      expect(updated.isExpand, true);
      expect(model.id, 'id1');
      expect(model.isExpand, false);
    });
  });
}
