import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_assistance_place_api.dart';

void main() {
  group('PlacePredictions', () {
    test('fromJson and fromMap', () {
      final jsonStr = '''{
        "predictions": [
          {
            "description": "London, UK",
            "matched_substrings": [{"length": 6, "offset": 0}],
            "place_id": "ChIJdd4hrwug2EcRmSrV3Vo6llI",
            "reference": "ChIJdd4hrwug2EcRmSrV3Vo6llI",
            "structured_formatting": {
              "main_text": "London",
              "main_text_matched_substrings": [{"length": 6, "offset": 0}],
              "secondary_text": "UK"
            },
            "terms": [
              {"offset": 0, "value": "London"},
              {"offset": 8, "value": "UK"}
            ],
            "types": ["locality", "political", "geocode"]
          }
        ],
        "status": "OK"
      }''';

      final placePredictions = PlacePredictions.fromJson(jsonStr);
      expect(placePredictions.status, 'OK');
      expect(placePredictions.predictions.length, 1);
      final prediction = placePredictions.predictions.first;
      expect(prediction.description, 'London, UK');
      expect(prediction.placeId, 'ChIJdd4hrwug2EcRmSrV3Vo6llI');
      expect(prediction.reference, 'ChIJdd4hrwug2EcRmSrV3Vo6llI');
      expect(prediction.matchedSubstrings.length, 1);
      expect(prediction.matchedSubstrings.first.length, 6);
      expect(prediction.matchedSubstrings.first.offset, 0);
      expect(prediction.structuredFormatting.mainText, 'London');
      expect(prediction.structuredFormatting.secondaryText, 'UK');
      expect(prediction.structuredFormatting.mainTextMatchedSubstrings.length, 1);
      expect(prediction.terms.length, 2);
      expect(prediction.terms[0].value, 'London');
      expect(prediction.terms[1].value, 'UK');
      expect(prediction.types, contains('locality'));
      expect(prediction.types, contains('geocode'));
    });

    test('Prediction.fromMap with empty lists', () {
      final map = {
        "description": "Test",
        "matched_substrings": [],
        "place_id": "id",
        "reference": "ref",
        "structured_formatting": {
          "main_text": "Main",
          "main_text_matched_substrings": [],
          "secondary_text": "Sec"
        },
        "terms": [],
        "types": []
      };
      final prediction = Prediction.fromMap(map);
      expect(prediction.description, 'Test');
      expect(prediction.matchedSubstrings, isEmpty);
      expect(prediction.terms, isEmpty);
      expect(prediction.types, isEmpty);
      expect(prediction.structuredFormatting.mainText, 'Main');
      expect(prediction.structuredFormatting.secondaryText, 'Sec');
    });
  });

  test('PlacePredictions equality and hashCode', () {
    final jsonStr = '''{
      "predictions": [
        {
          "description": "London, UK",
          "matched_substrings": [{"length": 6, "offset": 0}],
          "place_id": "ChIJdd4hrwug2EcRmSrV3Vo6llI",
          "reference": "ChIJdd4hrwug2EcRmSrV3Vo6llI",
          "structured_formatting": {
            "main_text": "London",
            "main_text_matched_substrings": [{"length": 6, "offset": 0}],
            "secondary_text": "UK"
          },
          "terms": [
            {"offset": 0, "value": "London"},
            {"offset": 8, "value": "UK"}
          ],
          "types": ["locality", "political", "geocode"]
        }
      ],
      "status": "OK"
    }''';
    final p1 = PlacePredictions.fromJson(jsonStr);
    final p2 = PlacePredictions.fromJson(jsonStr);
    expect(p1.status, p2.status);
    expect(p1.predictions.length, p2.predictions.length);
    expect(p1.predictions[0].description, p2.predictions[0].description);
  });

  test('Prediction equality and hashCode', () {
    final map = {
      "description": "Test",
      "matched_substrings": [],
      "place_id": "id",
      "reference": "ref",
      "structured_formatting": {
        "main_text": "Main",
        "main_text_matched_substrings": [],
        "secondary_text": "Sec"
      },
      "terms": [],
      "types": []
    };
    final p1 = Prediction.fromMap(map);
    final p2 = Prediction.fromMap(map);
    expect(p1.description, p2.description);
    expect(p1.placeId, p2.placeId);
    expect(p1.reference, p2.reference);
    expect(p1.structuredFormatting.mainText, p2.structuredFormatting.mainText);
  });

  test('MatchedSubstring and Term equality', () {
    final ms1 = MatchedSubstring.fromMap({"length": 1, "offset": 2});
    final ms2 = MatchedSubstring.fromMap({"length": 1, "offset": 2});
    expect(ms1.length, ms2.length);
    expect(ms1.offset, ms2.offset);
    final t1 = Term.fromMap({"offset": 1, "value": "A"});
    final t2 = Term.fromMap({"offset": 1, "value": "A"});
    expect(t1.offset, t2.offset);
    expect(t1.value, t2.value);
  });

  test('StructuredFormatting equality', () {
    final sf1 = StructuredFormatting.fromMap({
      "main_text": "Main",
      "main_text_matched_substrings": [],
      "secondary_text": "Sec"
    });
    final sf2 = StructuredFormatting.fromMap({
      "main_text": "Main",
      "main_text_matched_substrings": [],
      "secondary_text": "Sec"
    });
    expect(sf1.mainText, sf2.mainText);
    expect(sf1.secondaryText, sf2.secondaryText);
  });
}
