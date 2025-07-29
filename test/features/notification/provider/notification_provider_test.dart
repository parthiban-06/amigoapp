// test/features/notification/provider/notification_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/core/config/app_config.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/notification/models/get_notifications.dart';
import 'package:visaamigo/features/notification/provider/notification_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/remote/api_responseNavigationProvider {}

class MockUserGenericProvider extends Mock implements UserGenericProvider {}

// Helper function for updateNotifications
dynamic _dummyFromJson(Map<String, dynamic> json) => json;

void main() async {
  // Initialize environment configuration for tests
  TestWidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init(envFile: 'config/dev/.env');

  late NotificationProvider notificationProvider;
  late MockUserDetailRepo mockUserDetailRepo;
  late MockNavigationProvider mockNavigationProvider;
  late MockUserGenericProvider mockUserGenericProvider;

  setUp(() {
    mockUserDetailRepo = MockUserDetailRepo();
    mockNavigationProvider = MockNavigationProvider();
    mockUserGenericProvider = MockUserGenericProvider();

    notificationProvider = NotificationProvider(
      userDetailRepo: mockUserDetailRepo,
    );
  });

  group('NotificationProvider Initialization', () {
    test('should initialize with correct default values', () {
      expect(notificationProvider.itemLength, 4);
      expect(notificationProvider.notificationResponse, null);
      expect(notificationProvider.unreadMessage, isEmpty);
      expect(notificationProvider.isLoading, false);
    });

    test('should successfully load notifications', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.isLoading, false);
      expect(notificationProvider.notificationResponse, isNotNull);
      expect(notificationProvider.notificationResponse!.data.length, 2);
      verify(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .called(1);
    });

    test('should handle empty notifications response', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.emptyNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.isLoading, false);
      expect(notificationProvider.notificationResponse, isNotNull);
      expect(notificationProvider.notificationResponse!.data, isEmpty);
    });

    test('should handle error response during initialization', () async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 500,
                error: 'Server error',
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.isLoading, false);
      expect(notificationProvider.notificationResponse, null);
      verify(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .called(1);
    });

    test('should handle network exception during initialization', () async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenThrow(Exception('Network error'));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.isLoading, false);
      expect(notificationProvider.notificationResponse, null);
    });

    test('should announce unread count when notifications exist', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse, isNotNull);
      expect(notificationProvider.notificationResponse!.data.length, 2);
    });

    test('should handle notifications with unread count', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse, isNotNull);
      // Should have 1 unread notification (first one has read: false)
      final unreadCount = notificationProvider.notificationResponse!.data
          .where((item) => item.read == false)
          .length;
      expect(unreadCount, 1);
    });
  });

  group('NotificationProvider Navigation - moveToLink', () {
    setUp(() async {
      // Setup notifications
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '2',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      await notificationProvider.init();
    });

    test('should mark notification as read when moving to link', () async {
      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert
      expect(notificationProvider.notificationResponse!.data[0].read, true);
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });

    test('should not update already read notification', () async {
      // Act
      await notificationProvider.moveToLink('/profile', '2', 1);

      // Assert
      verifyNever(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '2',
      ));
    });

    test('should handle update notification error', () async {
      // Arrange
      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(
            statusCode: 500,
            error: 'Update failed',
          ));

      // Act & Assert - Should not throw
      await notificationProvider.moveToLink('/profile', '1', 0);
      expect(notificationProvider.isLoading, false);
    });

    test('should handle update notification exception', () async {
      // Arrange
      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenThrow(Exception('Update failed'));

      // Act & Assert - Should not throw
      await notificationProvider.moveToLink('/profile', '1', 0);
      expect(notificationProvider.isLoading, false);
    });

    test('should handle unknown link type', () async {
      // Act
      await notificationProvider.moveToLink('/unknown', '1', 0);

      // Assert
      expect(notificationProvider.isLoading, false);
    });

    test('should handle null link parameter', () async {
      // Act
      await notificationProvider.moveToLink(null, '1', 0);

      // Assert
      expect(notificationProvider.isLoading, false);
    });

    test('should handle null notification response', () async {
      // Arrange
      notificationProvider.notificationResponse = null;

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert
      expect(notificationProvider.isLoading, false);
    });

    test('should handle index out of bounds', () async {
      // Act
      await notificationProvider.moveToLink('/profile', '1', 999);

      // Assert
      expect(notificationProvider.isLoading, false);
    });

    test('should handle empty message ID parameter', () async {
      // Act
      await notificationProvider.moveToLink('/profile', '', 0);

      // Assert
      expect(notificationProvider.isLoading, false);
    });

    test('should handle notification with read as true', () async {
      // Arrange - Set the notification as already read
      notificationProvider.notificationResponse!.data[0] = notificationProvider
          .notificationResponse!.data[0]
          .copyWith(read: true);

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should not update since already read
      verifyNever(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      ));
    });

    test('should handle notification with read as false', () async {
      // Arrange - Ensure the notification is unread
      notificationProvider.notificationResponse!.data[0] = notificationProvider
          .notificationResponse!.data[0]
          .copyWith(read: false);

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should update since it's unread
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });
  });

  group('NotificationProvider State Management', () {
    test('should set loading state correctly during init', () async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return ApiResponse<NotificationResponse>(
          statusCode: 200,
          data: NotificationResponse.fromJson(
            MockNotificationData.sampleNotificationResponse,
          ),
        );
      });

      // Act
      final initFuture = notificationProvider.init();

      // Assert - Should be loading initially
      expect(notificationProvider.isLoading, true);

      await initFuture;

      // Assert - Should not be loading after completion
      expect(notificationProvider.isLoading, false);
    });

    test('should set loading state correctly during moveToLink', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return ApiResponse<dynamic>(statusCode: 200);
      });

      await notificationProvider.init();

      // Act
      final moveFuture = notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should be loading initially
      expect(notificationProvider.isLoading, true);

      await moveFuture;

      // Assert - Should not be loading after completion
      expect(notificationProvider.isLoading, false);
    });

    test('should handle loading state during error scenarios', () async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenThrow(Exception('Network error'));

      // Act
      await notificationProvider.init();

      // Assert - Should not be loading after error
      expect(notificationProvider.isLoading, false);
    });
  });

  group('NotificationProvider Edge Cases', () {
    test('should handle notification data with missing fields', () async {
      // Arrange
      final incompleteData = {
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

      final mockResponse = NotificationResponse.fromJson(incompleteData);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse, isNotNull);
      expect(notificationProvider.notificationResponse!.data.length, 1);
      expect(notificationProvider.notificationResponse!.data[0].title,
          'Test Title');
      expect(notificationProvider.notificationResponse!.data[0].read,
          true); // Default value
    });

    test('should handle notification data with null payload', () async {
      // Arrange
      final dataWithNullPayload = {
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
            // payload is missing
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      final mockResponse = NotificationResponse.fromJson(dataWithNullPayload);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      // Act
      await notificationProvider.init();

      // Assert
      expect(notificationProvider.notificationResponse, isNotNull);
      expect(
          notificationProvider.notificationResponse!.data[0].payload, isNull);
    });

    test('should handle notification with read as string "true"', () async {
      // Arrange
      final dataWithStringRead = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Title',
            'body': 'Test Body',
            'read': 'true', // String "true"
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      final mockResponse = NotificationResponse.fromJson(dataWithStringRead);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      await notificationProvider.init();

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should not update since already read
      verifyNever(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      ));
    });

    test('should handle notification with read as boolean true', () async {
      // Arrange
      final dataWithBooleanRead = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Title',
            'body': 'Test Body',
            'read': true, // Boolean true
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      final mockResponse = NotificationResponse.fromJson(dataWithBooleanRead);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      await notificationProvider.init();

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should not update since already read
      verifyNever(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      ));
    });

    test('should handle notification with read as string "false"', () async {
      // Arrange
      final dataWithStringFalse = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Title',
            'body': 'Test Body',
            'read': 'false', // String "false"
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      final mockResponse = NotificationResponse.fromJson(dataWithStringFalse);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      await notificationProvider.init();

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should update since it's unread
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });

    test('should handle notification with read as boolean false', () async {
      // Arrange
      final dataWithBooleanFalse = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Test Title',
            'body': 'Test Body',
            'read': false, // Boolean false
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          }
        ],
      };

      final mockResponse = NotificationResponse.fromJson(dataWithBooleanFalse);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      await notificationProvider.init();

      // Act
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should update since it's unread
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });
  });

  group('NotificationProvider Integration Tests', () {
    test('should handle complete notification flow', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      // Act - Initialize
      await notificationProvider.init();

      // Assert - Initial state
      expect(notificationProvider.notificationResponse, isNotNull);
      expect(notificationProvider.notificationResponse!.data.length, 2);
      expect(notificationProvider.notificationResponse!.data[0].read, false);
      expect(notificationProvider.notificationResponse!.data[1].read, true);

      // Act - Navigate to first notification
      await notificationProvider.moveToLink('/profile', '1', 0);

      // Assert - Should be marked as read
      expect(notificationProvider.notificationResponse!.data[0].read, true);
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });

    test('should handle multiple navigation calls', () async {
      // Arrange
      final mockResponse = NotificationResponse.fromJson(
        MockNotificationData.sampleNotificationResponse,
      );

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      await notificationProvider.init();

      // Act - Navigate multiple times
      await notificationProvider.moveToLink('/profile', '1', 0);
      await notificationProvider.moveToLink('/itinerary', '1', 0);
      await notificationProvider.moveToLink('/ticket', '1', 0);

      // Assert - Should only update once since it's already read after first call
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });

    test('should handle mixed read/unread notifications', () async {
      // Arrange
      final mixedData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'Unread Notification',
            'body': 'This is unread',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '2',
            'title': 'Read Notification',
            'body': 'This is read',
            'read': 'true',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/wallet'},
            'received_at': '2024-01-02T11:00:00Z',
          },
          {
            'id': '3',
            'title': 'Another Unread',
            'body': 'This is also unread',
            'read': 'false',
            'type': 'alert',
            'channel': 'email',
            'payload': {'link': '/ticket'},
            'received_at': '2024-01-03T12:00:00Z',
          }
        ],
      };

      final mockResponse = NotificationResponse.fromJson(mixedData);

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: mockResponse,
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '3',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      await notificationProvider.init();

      // Act - Navigate to unread notifications
      await notificationProvider.moveToLink('/profile', '1', 0);
      await notificationProvider.moveToLink(
          '/wallet', '2', 1); // Should not update
      await notificationProvider.moveToLink('/ticket', '3', 2);

      // Assert - Should update only unread notifications
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '3',
      )).called(1);
      verifyNever(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '2',
      ));
    });
  });
}
