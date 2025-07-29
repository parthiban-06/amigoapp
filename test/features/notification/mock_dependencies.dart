// test/features/notification/mock_dependencies.dart
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/remote/api_response.dart';

@GenerateMocks([
  UserDetailRepo,
  NavigationProvider,
  UserGenericProvider,
  BuildContext,
])
class MockDependencies {}

// Mock data helpers
class MockNotificationData {
  static final sampleNotificationResponse = {
    'status_code': 200,
    'message_key': 'success',
    'data': [
      {
        'id': '1',
        'title': 'Test Notification 1',
        'body': 'This is a test notification body',
        'read': 'false',
        'type': 'info',
        'channel': 'push',
        'payload': {'link': '/profile'},
        'received_at': '2024-01-01T10:00:00Z',
      },
      {
        'id': '2',
        'title': 'Test Notification 2',
        'body': 'This is another test notification',
        'read': 'true',
        'type': 'alert',
        'channel': 'email',
        'payload': {'link': '/wallet'},
        'received_at': '2024-01-02T11:00:00Z',
      },
    ],
  };

  static final emptyNotificationResponse = {
    'status_code': 200,
    'message_key': 'success',
    'data': [],
  };

  static final errorResponse = ApiResponse<dynamic>(
    statusCode: 500,
    error: 'Server error',
    messageKey: 'server_error',
  );

  static final successResponse = ApiResponse<dynamic>(
    statusCode: 200,
    data: sampleNotificationResponse,
  );
}
