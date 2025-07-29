import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/itinerary/models/add_itinerary_model.dart';
import 'package:visaamigo/features/itinerary/models/event_list_model.dart';
import 'package:visaamigo/features/itinerary/models/itinerary_location_search_model.dart';
import 'package:visaamigo/features/itinerary/models/timezone_model.dart';

void main() {
  group('EventList', () {
    test('fromJson and toJson', () {
      final json = {
        'lat': 1.0,
        'lan': 2.0,
        'start_time': '2024-07-03T10:00:00Z',
        'timezone': 'UTC',
        'title': 'Event Title',
        'id': 'evt1',
        'type': 'match',
        'address': '123 Main St',
      };
      final model = EventList.fromJson(json);
      expect(model.lat, 1.0);
      expect(model.lan, 2.0);
      expect(model.startTime, '2024-07-03T10:00:00Z');
      expect(model.timezone, 'UTC');
      expect(model.title, 'Event Title');
      expect(model.id, 'evt1');
      expect(model.type, 'match');
      expect(model.address, '123 Main St');
      expect(model.toJson()['lat'], 1.0);
    });
  });

  group('PlaceResponse', () {
    test('fromJson and toJson', () {
      final json = {
        'html_attributions': ['attr1'],
        'results': [
          {
            'formatted_address': 'Paris, France',
            'geometry': {
              'location': {'lat': 48.8566, 'lng': 2.3522},
              'viewport': {
                'northeast': {'lat': 49.0, 'lng': 2.5},
                'southwest': {'lat': 48.7, 'lng': 2.2}
              }
            },
            'name': 'Paris',
            'types': ['locality']
          }
        ],
        'status': 'OK'
      };
      final model = PlaceResponse.fromJson(json);
      expect(model.htmlAttributions, ['attr1']);
      expect(model.results!.first.name, 'Paris');
      expect(model.status, 'OK');
      expect(model.toJson()['status'], 'OK');
    });
  });

  group('TimeZoneInfo', () {
    test('fromJson and toJson', () {
      final json = {
        'dstOffset': 3600,
        'rawOffset': 7200,
        'status': 'OK',
        'timeZoneId': 'Europe/Paris',
        'timeZoneName': 'Central European Summer Time',
      };
      final model = TimeZoneInfo.fromJson(json);
      expect(model.dstOffset, 3600);
      expect(model.rawOffset, 7200);
      expect(model.status, 'OK');
      expect(model.timeZoneId, 'Europe/Paris');
      expect(model.timeZoneName, 'Central European Summer Time');
      expect(model.toJson()['timeZoneId'], 'Europe/Paris');
    });
  });

  group('EventModel', () {
    test('fromJson and toJson', () {
      final json = {
        'event_title': 'Trip',
        'id': 'evtid',
        'event_description': 'Desc',
        'event_date': '2024-07-03',
        'event_location': 'Paris',
        'event_start_time': '10:00',
        'event_end_time': '12:00',
        'event_type': 'holiday',
        'event_category': 'leisure',
        'event_time_zone_id': 'Europe/Paris',
        'event_time_zone': 'CEST',
        'event_dst_offset': 3600,
        'event_raw_offset': 7200,
        'event_latitude': 48.8566,
        'event_longitude': 2.3522,
      };
      final model = EventModel.fromJson(json);
      expect(model.eventTitle, 'Trip');
      expect(model.eventId, 'evtid');
      expect(model.eventDescription, 'Desc');
      expect(model.eventDate, '2024-07-03');
      expect(model.eventLocation, 'Paris');
      expect(model.eventStartTime, '10:00');
      expect(model.eventEndTime, '12:00');
      expect(model.eventType, 'holiday');
      expect(model.eventCategory, 'leisure');
      expect(model.eventTimeZoneId, 'Europe/Paris');
      expect(model.eventTimeZone, 'CEST');
      expect(model.eventDstOffset, 3600);
      expect(model.eventRawOffset, 7200);
      expect(model.eventLatitude, 48.8566);
      expect(model.eventLongitude, 2.3522);
      expect(model.toJson()['event_title'], 'Trip');
    });
  });
}
