import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/notification/models/get_notifications.dart';
import 'package:visaamigo/features/notification/provider/notification_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/remote/api_responseUserDetailRepo {}

// Helper function for updateNotifications
dynamic _dummyFromJson(Map<String, dynamic> json) => json;

void main() {
  late NotificationProvider notificationProvider;
  late MockUserDetailRepo mockUserDetailRepo;

  setUp(() {
    mockUserDetailRepo = MockUserDetailRepo();
    notificationProvider = NotificationProvider(
      userDetailRepo: mockUserDetailRepo,
    );
  });

  group('NotificationProvider Comprehensive Tests', () {
    test('should handle notification with missing payload link', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Notification',
            'body': 'Test Body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {}, // Empty payload
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(
          notificationProvider.notificationResponse!.data.first.payload?.link,
          '');
    });

    test('should handle notification with null payload', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Notification',
            'body': 'Test Body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            // No payload field
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(
          notificationProvider.notificationResponse!.data.first.payload, null);
    });

    test('should handle notification with invalid date format', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Notification',
            'body': 'Test Body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': 'invalid-date-format',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert - Should not throw and should use current date
      expect(notificationProvider.notificationResponse!.data.first.receivedAt,
          isA<DateTime>());
    });

    test('should handle notification with missing received_at field', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Notification',
            'body': 'Test Body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            // No received_at field
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert - Should use current date
      expect(notificationProvider.notificationResponse!.data.first.receivedAt,
          isA<DateTime>());
    });

    test('should handle notification with different read string values',
        () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Notification 1',
            'body': 'Test Body 1',
            'read': 'true',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '2',
            'title': 'Test Notification 2',
            'body': 'Test Body 2',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '3',
            'title': 'Test Notification 3',
            'body': 'Test Body 3',
            // No read field
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse!.data[0].read, true);
      expect(notificationProvider.notificationResponse!.data[1].read, false);
      expect(notificationProvider.notificationResponse!.data[2].read,
          true); // Default value
    });

    test('should handle notification with empty string values', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '',
            'title': '',
            'body': '',
            'read': 'false',
            'type': '',
            'channel': '',
            'payload': {'link': ''},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      final notification =
          notificationProvider.notificationResponse!.data.first;
      expect(notification.id, '');
      expect(notification.title, '');
      expect(notification.body, '');
      expect(notification.type, '');
      expect(notification.channel, '');
      expect(notification.payload?.link, '');
    });

    test('should handle notification with null values', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': null,
            'title': null,
            'body': null,
            'read': null,
            'type': null,
            'channel': null,
            'payload': null,
            'received_at': null,
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      final notification =
          notificationProvider.notificationResponse!.data.first;
      expect(notification.id, '');
      expect(notification.title, '');
      expect(notification.body, '');
      expect(notification.read, true); // Default when read field is missing
      expect(notification.type, '');
      expect(notification.channel, '');
      expect(notification.payload, null);
      expect(notification.receivedAt, isA<DateTime>());
    });

    test('should handle notification with special characters', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Notification with émojis 🎉 and special chars: &<>"\'',
            'body': 'Body with unicode: 你好世界 and symbols: ©®™',
            'read': 'false',
            'type': 'alert!',
            'channel': 'push-notification',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      final notification =
          notificationProvider.notificationResponse!.data.first;
      expect(notification.title,
          'Notification with émojis 🎉 and special chars: &<>"\'');
      expect(notification.body, 'Body with unicode: 你好世界 and symbols: ©®™');
      expect(notification.type, 'alert!');
      expect(notification.channel, 'push-notification');
    });

    test('should handle notification with deeply nested payload', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Notification',
            'body': 'Test Body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {
              'link': '/deep/nested/path',
              'extra_data': {
                'nested': {'value': 'test'}
              }
            },
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(
          notificationProvider.notificationResponse!.data.first.payload?.link,
          '/deep/nested/path');
    });

    test('should handle notification with malformed JSON gracefully', () async {
      // Arrange
      final malformedData = {
        'status_code': 'not_a_number', // Should be int
        'message_key': 123, // Should be string
        'data': 'not_an_array', // Should be array
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(malformedData),
              ));

      // Act & Assert - Should not throw
      expect(() => notificationProvider.init(), returnsNormally);
    });

    test('should handle notification with large data set', () async {
      // Arrange
      final largeDataSet = {
        'status_code': 200,
        'message_key': 'success',
        'data': List.generate(
            100,
            (index) => {
                  'id': index.toString(),
                  'title': 'Notification $index',
                  'body': 'Body for notification $index',
                  'read': index % 2 == 0 ? 'true' : 'false',
                  'type': 'info',
                  'channel': 'push',
                  'payload': {'link': '/profile'},
                  'received_at': '2024-01-01T10:00:00Z',
                }),
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(largeDataSet),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse!.data.length, 100);
      expect(notificationProvider.notificationResponse!.data[0].id, '0');
      expect(notificationProvider.notificationResponse!.data[99].id, '99');
    });

    test('should handle notification with different channel types', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Push Notification',
            'body': 'Push notification body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '2',
            'title': 'Email Notification',
            'body': 'Email notification body',
            'read': 'false',
            'type': 'info',
            'channel': 'email',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '3',
            'title': 'SMS Notification',
            'body': 'SMS notification body',
            'read': 'false',
            'type': 'info',
            'channel': 'sms',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(
          notificationProvider.notificationResponse!.data[0].channel, 'push');
      expect(
          notificationProvider.notificationResponse!.data[1].channel, 'email');
      expect(notificationProvider.notificationResponse!.data[2].channel, 'sms');
    });

    test('should handle notification with different types', () async {
      // Arrange
      final notificationData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Info Notification',
            'body': 'Info notification body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '2',
            'title': 'Alert Notification',
            'body': 'Alert notification body',
            'read': 'false',
            'type': 'alert',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '3',
            'title': 'Warning Notification',
            'body': 'Warning notification body',
            'read': 'false',
            'type': 'warning',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(notificationData),
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse!.data[0].type, 'info');
      expect(notificationProvider.notificationResponse!.data[1].type, 'alert');
      expect(
          notificationProvider.notificationResponse!.data[2].type, 'warning');
    });
  });
}
