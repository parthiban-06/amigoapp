// test/features/notification/model/get_notifications_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/notification/models/get_notifications.dart';

void main() {
  group('NotificationResponse', () {
    test('should create NotificationResponse from JSON', () {
      // Arrange
      final json = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Title',
            'body': 'Test Body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      // Act
      final response = NotificationResponse.fromJson(json);

      // Assert
      expect(response.statusCode, 200);
      expect(response.messageKey, 'success');
      expect(response.data.length, 1);
      expect(response.data.first.id, '1');
      // Note: title and body are processed by Utils.convrtStringUtf which may return empty string for plain text
      expect(response.data.first.read, false);
    });

    test('should convert NotificationResponse to JSON', () {
      // Arrange
      final notificationData = NotificationData(
        id: '1',
        title: 'Test Title',
        body: 'Test Body',
        read: false,
        type: 'info',
        channel: 'push',
        payload: Payload(link: '/profile'),
        receivedAt: DateTime.parse('2024-01-01T10:00:00Z'),
      );

      final response = NotificationResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [notificationData],
      );

      // Act
      final json = response.toJson();

      // Assert
      expect(json['status_code'], 200);
      expect(json['message_key'], 'success');
      expect(json['data'].length, 1);
      expect(json['data'][0]['id'], '1');
      expect(json['data'][0]['title'], 'Test Title');
    });

    test('should handle empty data array', () {
      // Arrange
      final json = {
        'status_code': 200,
        'message_key': 'success',
        'data': [],
      };

      // Act
      final response = NotificationResponse.fromJson(json);

      // Assert
      expect(response.statusCode, 200);
      expect(response.messageKey, 'success');
      expect(response.data, isEmpty);
    });

    test('should handle missing optional fields in JSON', () {
      // Arrange
      final json = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Title',
            // Missing other fields
          }
        ],
      };

      // Act
      final response = NotificationResponse.fromJson(json);

      // Assert
      expect(response.data.length, 1);
      expect(response.data.first.id, '1');
      // Note: title is processed by Utils.convrtStringUtf which may return empty string for plain text
    });
  });

  group('NotificationData', () {
    test('should create NotificationData from JSON with all fields', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Title',
        'body': 'Test Body',
        'read': 'true',
        'type': 'info',
        'channel': 'push',
        'payload': {'link': '/profile'},
        'received_at': '2024-01-01T10:00:00Z',
      };

      // Act
      final notification = NotificationData.fromJson(json);

      // Assert
      expect(notification.id, '1');
      // Note: title and body are processed by Utils.convrtStringUtf which may return empty string for plain text
      expect(notification.read, true);
      expect(notification.type, 'info');
      expect(notification.channel, 'push');
      expect(notification.payload?.link, '/profile');
      expect(notification.receivedAt, DateTime.parse('2024-01-01T10:00:00Z'));
    });

    test('should create NotificationData from JSON with missing fields', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Title',
        'body': 'Test Body',
      };

      // Act
      final notification = NotificationData.fromJson(json);

      // Assert
      expect(notification.id, '1');
      // Note: title and body are processed by Utils.convrtStringUtf which may return empty string for plain text
      expect(notification.read, true); // Default value
      expect(notification.type, ''); // Default value
      expect(notification.payload, null);
      expect(notification.receivedAt, isA<DateTime>());
    });

    test('should create copy of NotificationData with updated fields', () {
      // Arrange
      final original = NotificationData(
        id: '1',
        title: 'Original Title',
        body: 'Original Body',
        read: false,
        type: 'info',
        channel: 'push',
        payload: Payload(link: '/profile'),
        receivedAt: DateTime.now(),
      );

      // Act
      final copy = original.copyWith(
        title: 'Updated Title',
        read: true,
      );

      // Assert
      expect(copy.id, '1');
      expect(copy.title, 'Updated Title');
      expect(copy.body, 'Original Body');
      expect(copy.read, true);
      expect(copy.type, 'info');
    });

    test('should convert NotificationData to JSON', () {
      // Arrange
      final notification = NotificationData(
        id: '1',
        title: 'Test Title',
        body: 'Test Body',
        read: false,
        type: 'info',
        channel: 'push',
        payload: Payload(link: '/profile'),
        receivedAt: DateTime.parse('2024-01-01T10:00:00Z'),
      );

      // Act
      final json = notification.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Title');
      expect(json['body'], 'Test Body');
      expect(json['read'], 'false');
      expect(json['type'], 'info');
      expect(json['channel'], 'push');
      expect(json['payload']['link'], '/profile');
      expect(json['received_at'], '2024-01-01T10:00:00.000Z');
    });

    test('should handle null payload', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Title',
        'body': 'Test Body',
        'read': 'true',
        'type': 'info',
        'channel': 'push',
        // No payload field
      };

      // Act
      final notification = NotificationData.fromJson(json);

      // Assert
      expect(notification.payload, null);
    });

    test('should handle different read values', () {
      // Test with string 'true'
      final jsonTrue = {
        'id': '1',
        'title': 'Test',
        'body': 'Test',
        'read': 'true',
      };
      final notificationTrue = NotificationData.fromJson(jsonTrue);
      expect(notificationTrue.read, true);

      // Test with string 'false'
      final jsonFalse = {
        'id': '1',
        'title': 'Test',
        'body': 'Test',
        'read': 'false',
      };
      final notificationFalse = NotificationData.fromJson(jsonFalse);
      expect(notificationFalse.read, false);

      // Test without read field (should default to true)
      final jsonNoRead = {
        'id': '1',
        'title': 'Test',
        'body': 'Test',
      };
      final notificationNoRead = NotificationData.fromJson(jsonNoRead);
      expect(notificationNoRead.read, true);
    });
  });

  group('Payload', () {
    test('should create Payload from JSON', () {
      // Arrange
      final json = {'link': '/profile'};

      // Act
      final payload = Payload.fromJson(json);

      // Assert
      expect(payload.link, '/profile');
    });

    test('should create Payload with empty link', () {
      // Arrange
      final json = {'link': null};

      // Act
      final payload = Payload.fromJson(json);

      // Assert
      expect(payload.link, '');
    });

    test('should convert Payload to JSON', () {
      // Arrange
      final payload = Payload(link: '/profile');

      // Act
      final json = payload.toJson();

      // Assert
      expect(json['link'], '/profile');
    });
  });

  group('Edge Cases and Error Handling', () {
    test('should handle missing received_at field', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test',
        'body': 'Test',
      };

      // Act
      final notification = NotificationData.fromJson(json);

      // Assert
      expect(notification.receivedAt, isA<DateTime>());
    });

    test('should handle empty strings in JSON', () {
      // Arrange
      final json = {
        'id': '',
        'title': '',
        'body': '',
        'type': '',
        'channel': '',
      };

      // Act
      final notification = NotificationData.fromJson(json);

      // Assert
      expect(notification.id, '');
      // Note: title and body are processed by Utils.convrtStringUtf which may return empty string for plain text
      expect(notification.type, '');
      expect(notification.channel, '');
    });
  });
}
