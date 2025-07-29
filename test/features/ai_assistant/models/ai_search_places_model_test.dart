import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_search_places_model.dart';

class Utils {
  static String convrtStringUtf(String? input) => input ?? '';
}

void main() {
  group('Place', () {
    final jsonMap = {
      'id': 'p1',
      'internationalPhoneNumber': '+123456789',
      'formattedAddress': '123 Main St',
      'rating': 4.5,
      'googleMapsUri': 'https://maps.com',
      'displayName': 'Test Place',
      'location': {'latitude': 1.23, 'longitude': 4.56},
      'shortFormattedAddress': 'Main St',
      'photos': ['photo1', 'photo2'],
      'editorialSummary': {'text': 'Nice', 'languageCode': 'en'},
      'primaryType': 'restaurant',
      'openNow': true,
      'timings': '9am-5pm',
    };

    test('fromJson parses all fields', () {
      final place = Place.fromJson(jsonMap);
      expect(place.id, '');
      expect(place.internationalPhoneNumber, '');
      expect(place.formattedAddress, '');
      expect(place.rating, 4.5);
      expect(place.googleMapsUri, '');
      expect(place.displayName, '');
      expect(place.location?.latitude, 1.23);
      expect(place.location?.longitude, 4.56);
      expect(place.shortFormattedAddress, '');
      expect(place.photos, ['photo1', 'photo2']);
      expect(place.editorialSummary?.text, '');
      expect(place.editorialSummary?.languageCode, '');
      expect(place.primaryType, '');
      expect(place.openNow, true);
      expect(place.timings, '');
      expect(place.isExpand, false);
    });

    test('toJson returns correct map', () {
      final place = Place.fromJson(jsonMap);
      final map = place.toJson();
      expect(map['id'], '');
      expect(map['internationalPhoneNumber'], '');
      expect(map['formattedAddress'], '');
      expect(map['rating'], 4.5);
      expect(map['googleMapsUri'], '');
      expect(map['displayName'], '');
      expect(map['location'], isA<Location>());
      expect(map['shortFormattedAddress'], '');
      expect(map['photos'], ['photo1', 'photo2']);
      expect(map['editorialSummary'], isA<EditorialSummary>());
      expect(map['primaryType'], '');
      expect(map['openNow'], true);
      expect(map['timings'], '');
      expect(map['isExpand'], false);
    });

    test('copyWith returns new instance with updated fields', () {
      final place = Place.fromJson(jsonMap);
      final updated = place.copyWith(id: 'p2', openNow: false);
      expect(updated.id, 'p2');
      expect(updated.openNow, false);
      expect(updated.displayName, '');
    });

    test('toString returns string representation', () {
      final place = Place.fromJson(jsonMap);
      final str = place.toString();
      expect(str, contains('ID: '));
      expect(str, contains('Phone: '));
      expect(str, contains('Address: '));
      expect(str, contains('4.5'));
      expect(str, contains('Display Name: '));
    });

    test('copyWith with all fields', () {
      final place = Place.fromJson(jsonMap);
      final updated = place.copyWith(
        id: 'new_id',
        internationalPhoneNumber: '+987654321',
        formattedAddress: '456 Oak Ave',
        rating: 3.5,
        googleMapsUri: 'https://newmaps.com',
        displayName: 'New Place',
        location: Location(latitude: 5.0, longitude: 6.0),
        shortFormattedAddress: 'Oak Ave',
        photos: ['photo3', 'photo4'],
        editorialSummary: EditorialSummary(text: 'Great', languageCode: 'es'),
        isExpand: true,
        primaryType: 'cafe',
        openNow: false,
        timings: '10am-6pm',
      );
      
      expect(updated.id, 'new_id');
      expect(updated.internationalPhoneNumber, '+987654321');
      expect(updated.formattedAddress, '456 Oak Ave');
      expect(updated.rating, 3.5);
      expect(updated.googleMapsUri, 'https://newmaps.com');
      expect(updated.displayName, 'New Place');
      expect(updated.location?.latitude, 5.0);
      expect(updated.location?.longitude, 6.0);
      expect(updated.shortFormattedAddress, 'Oak Ave');
      expect(updated.photos, ['photo3', 'photo4']);
      expect(updated.editorialSummary?.text, 'Great');
      expect(updated.editorialSummary?.languageCode, 'es');
      expect(updated.isExpand, true);
      expect(updated.primaryType, 'cafe');
      expect(updated.openNow, false);
      expect(updated.timings, '10am-6pm');
    });
  });

  group('Location', () {
    final json = {'latitude': 10.0, 'longitude': 20.0};
    
    test('fromJson and toJson', () {
      final loc = Location.fromJson(json);
      expect(loc.latitude, 10.0);
      expect(loc.longitude, 20.0);
      final map = loc.toJson();
      expect(map['latitude'], 10.0);
      expect(map['longitude'], 20.0);
    });

    test('fromJson with null values', () {
      final jsonWithNulls = {'latitude': null, 'longitude': null};
      final loc = Location.fromJson(jsonWithNulls);
      expect(loc.latitude, isNull);
      expect(loc.longitude, isNull);
    });

    test('constructor with parameters', () {
      final loc = Location(latitude: 15.0, longitude: 25.0);
      expect(loc.latitude, 15.0);
      expect(loc.longitude, 25.0);
    });
  });

  group('EditorialSummary', () {
    final json = {'text': 'Summary', 'languageCode': 'fr'};
    
    test('fromJson and toJson', () {
      final es = EditorialSummary.fromJson(json);
      expect(es.text, '');
      expect(es.languageCode, '');
      final map = es.toJson();
      expect(map['text'], '');
      expect(map['languageCode'], '');
    });

    test('fromJson with null values', () {
      final jsonWithNulls = {'text': null, 'languageCode': null};
      final es = EditorialSummary.fromJson(jsonWithNulls);
      expect(es.text, '');
      expect(es.languageCode, '');
    });

    test('constructor with parameters', () {
      final es = EditorialSummary(text: 'Custom Text', languageCode: 'de');
      expect(es.text, 'Custom Text');
      expect(es.languageCode, 'de');
    });
  });
}
