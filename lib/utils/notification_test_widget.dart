import 'package:flutter/material.dart';
import 'package:visaamigo/utils/notification_test_helper.dart';

/// A test widget for testing notification functionality
/// You can add this to any screen for testing purposes
class NotificationTestWidget extends StatelessWidget {
  const NotificationTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Notification Test Panel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () =>
                    NotificationTestHelper.testForegroundNotification(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Foreground'),
              ),
              ElevatedButton(
                onPressed: () => NotificationTestHelper.testFirebaseToken(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Token'),
              ),
              ElevatedButton(
                onPressed: () =>
                    NotificationTestHelper.testNotificationPermissions(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Permissions'),
              ),
              ElevatedButton(
                onPressed: () => NotificationTestHelper.showCustomNotification(
                  title: 'Custom Notification',
                  body:
                      'This is a test notification sent at ${DateTime.now().toString()}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Custom Notification'),
              ),
              ElevatedButton(
                onPressed: () =>
                    NotificationTestHelper.testForegroundNotificationCallback(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Callback'),
              ),
              ElevatedButton(
                onPressed: () =>
                    NotificationTestHelper.testIOSNotificationData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test iOS Data'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Example usage in a screen:
///
/// ```dart
/// class MyScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('My Screen')),
///       body: Column(
///         children: [
///           // Your existing content
///           Expanded(
///             child: YourContent(),
///           ),
///           // Add the test widget at the bottom
///           if (kDebugMode) // Only show in debug mode
///             const NotificationTestWidget(),
///         ],
///       ),
///     );
///   }
/// }
/// ```
