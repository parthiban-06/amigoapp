// test/features/notification/notification_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/notification/models/get_notifications.dart';
import 'package:visaamigo/features/notification/provider/notification_provider.dart';
import 'package:visaamigo/features/notification/screens/notification_screen.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/remote/api_response.dart';

import 'mock_dependencies.dart';

// Manual mocks
class MockUserDetailRepo extends Mock implements UserDetailRepo {}

// Helper function for updateNotifications
dynamic _dummyFromJson(Map<String, dynamic> json) => json;

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: child,
    );
  }
}

void main() {
  late MockUserDetailRepo mockUserDetailRepo;
  late NotificationProvider notificationProvider;

  setUp(() {
    mockUserDetailRepo = MockUserDetailRepo();
    notificationProvider = NotificationProvider(
      userDetailRepo: mockUserDetailRepo,
    );
  });

  group('NotificationScreen Widget Tests', () {
    testWidgets('should display loading state initially',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => Future.delayed(
                Duration(seconds: 1),
                () => ApiResponse<NotificationResponse>(
                  statusCode: 200,
                  data: NotificationResponse.fromJson(
                    MockNotificationData.sampleNotificationResponse,
                  ),
                ),
              ));

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display notifications list',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.sampleNotificationResponse,
                ),
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Notification 1'), findsOneWidget);
      expect(find.text('Test Notification 2'), findsOneWidget);
      expect(find.text('This is a test notification body'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display empty state when no notifications',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.emptyNotificationResponse,
                ),
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No notifications'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should handle notification tap', (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.sampleNotificationResponse,
                ),
              ));

      when(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on first notification
      await tester.tap(find.text('Test Notification 1'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });

    testWidgets('should display different icons for read/unread notifications',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.sampleNotificationResponse,
                ),
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should find SVG images for both read and unread notifications
      expect(find.byType(SvgPicture), findsNWidgets(2));
    });

    testWidgets('should display notification title and body',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.sampleNotificationResponse,
                ),
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Notification 1'), findsOneWidget);
      expect(find.text('Test Notification 2'), findsOneWidget);
      expect(find.text('This is a test notification body'), findsOneWidget);
      expect(find.text('This is another test notification'), findsOneWidget);
    });

    testWidgets('should handle error state gracefully',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 500,
                error: 'Server error',
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should not crash and should show empty state
      expect(find.byType(NotificationScreen), findsOneWidget);
    });

    testWidgets('should handle network timeout gracefully',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenThrow(Exception('Network timeout'));

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should not crash
      expect(find.byType(NotificationScreen), findsOneWidget);
    });

    testWidgets('should display app bar with correct title',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.sampleNotificationResponse,
                ),
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('should handle multiple notifications correctly',
        (WidgetTester tester) async {
      // Arrange
      final multipleNotificationsData = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'title': 'First Notification',
            'body': 'First notification body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/profile'},
            'received_at': '2024-01-01T10:00:00Z',
          },
          {
            'id': '2',
            'title': 'Second Notification',
            'body': 'Second notification body',
            'read': 'true',
            'type': 'alert',
            'channel': 'email',
            'payload': {'link': '/wallet'},
            'received_at': '2024-01-02T11:00:00Z',
          },
          {
            'id': '3',
            'title': 'Third Notification',
            'body': 'Third notification body',
            'read': 'false',
            'type': 'info',
            'channel': 'push',
            'payload': {'link': '/ticket'},
            'received_at': '2024-01-03T12:00:00Z',
          },
        ],
      };

      when(mockUserDetailRepo.getNotifications(NotificationResponse.fromJson))
          .thenAnswer((_) async => ApiResponse<NotificationResponse>(
                statusCode: 200,
                data: NotificationResponse.fromJson(multipleNotificationsData),
              ));

      await notificationProvider.init();

      // Act
      await tester.pumpWidget(
        TestApp(
          child: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('First Notification'), findsOneWidget);
      expect(find.text('Second Notification'), findsOneWidget);
      expect(find.text('Third Notification'), findsOneWidget);
      expect(find.text('First notification body'), findsOneWidget);
      expect(find.text('Second notification body'), findsOneWidget);
      expect(find.text('Third notification body'), findsOneWidget);
    });
  });
}
