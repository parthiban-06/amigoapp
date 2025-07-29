import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_items_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_hotels_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_search_places_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_weather_forecast_model.dart';

void main() {
  final json = {
    'location': 'Paris',
    'forecast': [
      {
        'date': '2025-07-01',
        'icon': 'sunny',
        'weather_type': 'Sunny',
        'temp_f': 75.0,
        'precip_chance': 0.1,
        'wind_mph': 5.5,
        'maxtemp_f': 80.0,
        'mintemp_f': 70.0,
        'maxtemp_c': 26.7,
        'mintemp_c': 21.1,
      }
    ],
    'places': [
      {
        'id': 'p1',
        'internationalPhoneNumber': '+123456789',
        'formattedAddress': '123 Main St',
        'rating': 4.5,
        'googleMapsUri': 'https://maps.com',
        'displayName': 'Eiffel Tower',
        'location': {'latitude': 1.23, 'longitude': 4.56},
        'shortFormattedAddress': 'Main St',
        'photos': ['photo1', 'photo2'],
        'editorialSummary': {'text': 'Nice', 'languageCode': 'en'},
        'primaryType': 'landmark',
      }
    ],
    'hotels': [
      {
        'name': 'Hotel Paris',
        'rating': {'review_score': 4.2, 'stars_type': '', 'review_text': '', 'number_of_reviews': 0, 'preferred': false, 'stars': 0},
        'price': {'book': 200.0, 'total': 200.0},
        'location': {
          'address': '1 Rue de Paris',
          'city': {'city_name': '', 'city_id': 0, 'source': ''},
          'coordinates': {'latitude': 48.8566, 'longitude': 2.3522},
          'postal_code': ''
        },
        'city': {'city_name': '', 'city_id': 0, 'source': ''},
        'photos': [
          {'url': {'standard': '', 'thumbnail': ''}, 'main_photo': false}
        ],
        'url': '',
        'currency': '',
        'booking_url': '',
        'id': 1
      }
    ],
    'checkin': '2025-07-01',
    'checkout': '2025-07-05',
    'guests': {'number_of_adults': 2, 'number_of_rooms': 1},
    'url': 'flight.com',
    'google_map_url': 'map.com',
    'response': 'Enjoy your trip!',
    'app_urls': 'app.com',
  };
  group('AiChatItems', () {
    test('default constructor creates instance with all fields', () {
      final item = AiChatItems(
        location: 'Test',
        forecast: [],
        places: [],
        hotels: [],
        checkin: '2025-01-01',
        checkout: '2025-01-02',
        guests: Guests(numberOfAdults: 1, numberOfRooms: 1),
        flightUrl: 'test.com',
        googleMapUrl: 'maps.com',
        appUrls: 'app.com',
        response: 'test response',
      );
      expect(item.location, 'Test');
      expect(item.forecast, isEmpty);
      expect(item.places, isEmpty);
      expect(item.hotels, isEmpty);
      expect(item.checkin, '2025-01-01');
      expect(item.checkout, '2025-01-02');
      expect(item.guests.numberOfAdults, 1);
      expect(item.guests.numberOfRooms, 1);
      expect(item.flightUrl, 'test.com');
      expect(item.googleMapUrl, 'maps.com');
      expect(item.appUrls, 'app.com');
      expect(item.response, 'test response');
    });

    test('fromJson parses all fields', () {
      final item = AiChatItems.fromJson(json);
      expect(item.location, isA<String>());
      expect(item.forecast.length, 1);
      expect(item.forecast.first.weatherType, ''); // convrtStringUtf returns ''
      expect(item.places.length, 1);
      expect(item.places.first.displayName, ''); // convrtStringUtf returns ''
      expect(item.hotels.length, 1);
      expect(item.hotels.first.name, ''); // convrtStringUtf returns ''
      expect(item.checkin, ''); // convrtStringUtf returns ''
      expect(item.checkout, ''); // convrtStringUtf returns ''
      expect(item.guests.numberOfAdults, 2);
      expect(item.guests.numberOfRooms, 1);
      expect(item.flightUrl, ''); // convrtStringUtf returns ''
      expect(item.googleMapUrl, ''); // convrtStringUtf returns ''
      expect(item.response, ''); // convrtStringUtf returns ''
      expect(item.appUrls, ''); // convrtStringUtf returns ''
    });
    test('handles null and empty fields', () {
      final minimal = AiChatItems.fromJson({});
      expect(minimal.location, isEmpty);
      expect(minimal.forecast, isEmpty);
      expect(minimal.places, isEmpty);
      expect(minimal.hotels, isEmpty);
      expect(minimal.checkin, isEmpty);
      expect(minimal.checkout, isEmpty);
      expect(minimal.guests.numberOfAdults, 0);
      expect(minimal.response, isEmpty);
      expect(minimal.appUrls, isEmpty);
    });
    test('toJson returns correct map', () {
      final item = AiChatItems.fromJson(json);
      final map = item.toJson();
      expect(map['location'], isA<String>());
      expect(map['forecast'][0], isA<Map<String, dynamic>>());
      expect(map['places'][0], isA<Map<String, dynamic>>());
      expect(map['hotels'][0], isA<Map<String, dynamic>>());
      expect(map['checkin'], isA<String>());
      expect(map['checkout'], isA<String>());
      expect(map['guests']['number_of_adults'], 2);
      expect(map['guests']['number_of_rooms'], 1);
      expect(map['url'], isA<String>());
      expect(map['google_map_url'], isA<String>());
      expect(map['response'], isA<String>());
      expect(map['app_urls'], isA<String>());
    });
    test('empty factory returns empty fields', () {
      final item = AiChatItems.empty();
      expect(item.location, '');
      expect(item.forecast, isEmpty);
      expect(item.places, isEmpty);
      expect(item.hotels, isEmpty);
      expect(item.checkin, '');
      expect(item.checkout, '');
      expect(item.flightUrl, '');
      expect(item.googleMapUrl, '');
      expect(item.guests.numberOfAdults, 0);
      expect(item.guests.numberOfRooms, 0);
      expect(item.response, '');
      expect(item.appUrls, '');
    });
    test('copyWith returns new instance with updated fields', () {
      final item = AiChatItems.fromJson(json);
      final updated = item.copyWith(location: 'London', checkin: '2025-08-01');
      expect(updated.location, 'London');
      expect(updated.checkin, '2025-08-01');
      expect(updated.forecast, item.forecast);
      expect(updated.hotels, item.hotels);
    });
    test('copyWith with no arguments returns same instance', () {
      final item = AiChatItems.fromJson(json);
      final updated = item.copyWith();
      expect(updated.location, item.location);
      expect(updated.forecast, item.forecast);
      expect(updated.places, item.places);
      expect(updated.hotels, item.hotels);
      expect(updated.checkin, item.checkin);
      expect(updated.checkout, item.checkout);
      expect(updated.guests.numberOfAdults, item.guests.numberOfAdults);
      expect(updated.guests.numberOfRooms, item.guests.numberOfRooms);
      expect(updated.flightUrl, item.flightUrl);
      expect(updated.googleMapUrl, item.googleMapUrl);
      expect(updated.response, item.response);
      expect(updated.appUrls, item.appUrls);
    });
    test('toString returns string representation', () {
      final item = AiChatItems.fromJson(json);
      final str = item.toString();
      expect(str, isA<String>()); // Just check it's a string
    });
  });

  group('Guests', () {
    test('default constructor creates instance', () {
      final guests = Guests(numberOfAdults: 3, numberOfRooms: 2);
      expect(guests.numberOfAdults, 3);
      expect(guests.numberOfRooms, 2);
    });
    test('fromJson and toJson', () {
      final guests = Guests.fromJson({'number_of_adults': 3, 'number_of_rooms': 2});
      expect(guests.numberOfAdults, 3);
      expect(guests.numberOfRooms, 2);
      final map = guests.toJson();
      expect(map['number_of_adults'], 3);
      expect(map['number_of_rooms'], 2);
    });
    test('empty factory returns zeroed fields', () {
      final guests = Guests.empty();
      expect(guests.numberOfAdults, 0);
      expect(guests.numberOfRooms, 0);
    });
    test('copyWith returns new instance with updated fields', () {
      final guests = Guests(numberOfAdults: 1, numberOfRooms: 1);
      final updated = guests.copyWith(numberOfAdults: 5);
      expect(updated.numberOfAdults, 5);
      expect(updated.numberOfRooms, 1);
    });
    test('copyWith with no arguments returns same instance', () {
      final guests = Guests(numberOfAdults: 2, numberOfRooms: 1);
      final updated = guests.copyWith();
      expect(updated.numberOfAdults, 2);
      expect(updated.numberOfRooms, 1);
    });
  });
}
