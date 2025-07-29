// test/utils/utils_widget_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/utils/utils.dart';

void main() {
  group('Utils Widget Integration Tests', () {
    late BuildContext testContext;

    testWidgets('should complete full popup workflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context; // Store context for later use
              return Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Utils.visaPopup(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Integration Test'),
                          content: const Text('This is a test popup'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text('Show Popup'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final date =
                            await Utils.pickDate(context, DateTime.now());
                        // Handle date selection
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Test popup flow
      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();
      expect(find.text('Integration Test'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Integration Test'), findsNothing);

      // Test date picker flow
      await tester.tap(find.text('Pick Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Cancel the date picker
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle focus operations in real UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const TextField(
                    decoration: InputDecoration(hintText: 'Test Field')),
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => Utils.hideKeyboard(context),
                    child: const Text('Hide Keyboard'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Focus on text field
      await tester.tap(find.byType(TextField));
      await tester.pump();

      // Hide keyboard
      await tester.tap(find.text('Hide Keyboard'));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should handle multiple popup types in sequence',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Utils.walletPopupTravelCredit(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Wallet Popup'),
                          content: const Text('Travel Credit'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text('Show Wallet Popup'),
                    ),
                    ElevatedButton(
                      onPressed: () => Utils.deleteCompanionPopup(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Delete Companion'),
                          content: const Text('Are you sure?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text('Show Delete Popup'),
                    ),
                    ElevatedButton(
                      onPressed: () => Utils.rateUsPopup(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Rate Us'),
                          content: const Text('Please rate our app'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Later'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Rate Now'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text('Show Rate Popup'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Test wallet popup
      await tester.tap(find.text('Show Wallet Popup'));
      await tester.pumpAndSettle();
      expect(find.text('Travel Credit'), findsOneWidget);

      // Close wallet popup
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Travel Credit'), findsNothing);

      // Test delete popup
      await tester.tap(find.text('Show Delete Popup'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure?'), findsOneWidget);

      // Cancel delete popup
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Are you sure?'), findsNothing);

      // Test rate popup
      await tester.tap(find.text('Show Rate Popup'));
      await tester.pumpAndSettle();
      expect(find.text('Please rate our app'), findsOneWidget);

      // Close rate popup
      await tester.tap(find.text('Later'));
      await tester.pumpAndSettle();
      expect(find.text('Please rate our app'), findsNothing);
    });

    testWidgets('should handle date and time picker workflow',
        (WidgetTester tester) async {
      DateTime? selectedDate;
      TimeOfDay? selectedTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      selectedDate =
                          await Utils.pickDate(context, DateTime(2024, 1, 1));
                    },
                    child: const Text('Pick Date'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      selectedTime = await Utils.pickTime(
                          context, const TimeOfDay(hour: 10, minute: 30), true);
                    },
                    child: const Text('Pick Time 24h'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      selectedTime = await Utils.pickTime(context, null, false);
                    },
                    child: const Text('Pick Time 12h'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Test date picker
      await tester.tap(find.text('Pick Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Cancel date picker
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsNothing);

      // Test 24h time picker
      await tester.tap(find.text('Pick Time 24h'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);

      // Cancel time picker
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsNothing);

      // Test 12h time picker
      await tester.tap(find.text('Pick Time 12h'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);

      // Cancel time picker
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsNothing);
    });

    testWidgets('should handle keyboard and focus operations',
        (WidgetTester tester) async {
      final TextEditingController controller1 = TextEditingController();
      final TextEditingController controller2 = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  TextField(
                    controller: controller1,
                    decoration: const InputDecoration(hintText: 'Field 1'),
                  ),
                  TextField(
                    controller: controller2,
                    decoration: const InputDecoration(hintText: 'Field 2'),
                  ),
                  ElevatedButton(
                    onPressed: () => Utils.hideKeyboard(context),
                    child: const Text('Hide Keyboard'),
                  ),
                  ElevatedButton(
                    onPressed: () => Utils.showKeyboard(context),
                    child: const Text('Show Keyboard'),
                  ),
                  ElevatedButton(
                    onPressed: () => Utils.removeFocus(),
                    child: const Text('Remove Focus'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Focus on first field
      await tester.tap(find.byWidget(TextField(
        controller: controller1,
        decoration: const InputDecoration(hintText: 'Field 1'),
      )));
      await tester.pump();

      // Test hide keyboard
      await tester.tap(find.text('Hide Keyboard'));
      await tester.pump();

      // Test show keyboard
      await tester.tap(find.text('Show Keyboard'));
      await tester.pump();

      // Test remove focus
      await tester.tap(find.text('Remove Focus'));
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should handle error scenarios gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Test popup with null child - should not crash
                      try {
                        Utils.visaPopup(
                          context: context,
                          child: Container(), // Empty container instead of null
                        );
                      } catch (e) {
                        // Handle gracefully
                      }
                    },
                    child: const Text('Test Error Handling'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Test date picker with past date
                      final pastDate = DateTime(2020, 1, 1);
                      final result = await Utils.pickDate(context, pastDate);
                      // Should use current date as minimum
                    },
                    child: const Text('Test Past Date'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Error Handling'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Past Date'));
      await tester.pumpAndSettle();

      // Should show date picker even with past date
      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle rapid user interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Utils.visaPopup(
                      context: context,
                      child: AlertDialog(
                        title: const Text('Rapid Test'),
                        content: const Text('Testing rapid interactions'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Quick Popup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Rapid taps
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Quick Popup'));
        await tester.pump(const Duration(milliseconds: 100));

        if (find.text('Close').evaluate().isNotEmpty) {
          await tester.tap(find.text('Close'));
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      // Should handle gracefully without crashes
      expect(find.text('Quick Popup'), findsOneWidget);
    });
  });
}
