// test/features/notification/notification_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/notification/models/get_notifications.dart';
import 'package:visaamigo/features/notification/provider/notification_provider.dart';
import 'package:visaamigo/features/notification/screens/notification_screen.dart';
import 'package:visaamigo/remote/api_response.dart';

import '../../test_coverage/coverage_login_test.dart';
import 'mock_dependencies.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  dynamic _dummyFromJson(Map<String, dynamic> json) => json;

  group('Notification Integration Tests', () {
    late MockUserDetailRepo mockUserDetailRepo;
    late NotificationProvider notificationProvider;

    setUp(() {
      mockUserDetailRepo = MockUserDetailRepo();
      notificationProvider = NotificationProvider(
        userDetailRepo: mockUserDetailRepo,
      );
    });

    testWidgets('should complete full notification flow',
        (WidgetTester tester) async {
      // Arrange
      when(mockUserDetailRepo.getNotifications(_dummyFromJson))
          .thenAnswer((_) async => ApiResponse(
                statusCode: 200,
                data: NotificationResponse.fromJson(
                  MockNotificationData.sampleNotificationResponse,
                ),
              ));

      when(mockUserDetailRepo.updateNotifications(_dummyFromJson, any, "1"))
          .thenAnswer((_) async => ApiResponse<dynamic>(statusCode: 200));

      // Act & Assert
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NotificationProvider>.value(
            value: notificationProvider,
            child: const NotificationScreen(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Verify notifications are displayed
      expect(find.text('Test Notification 1'), findsOneWidget);
      expect(find.text('Test Notification 2'), findsOneWidget);

      // Tap on unread notification
      await tester.tap(find.text('Test Notification 1'));
      await tester.pumpAndSettle();

      // Verify API was called to mark as read
      verify(mockUserDetailRepo.updateNotifications(
        _dummyFromJson,
        {'read': 'true'},
        '1',
      )).called(1);
    });
  });
}
