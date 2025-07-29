// test/utils/utils_datetime_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/utils/utils.dart';

void main() {
  group('Utils DateTime Specific Tests', () {
    testWidgets('should handle date picker edge cases',
        (WidgetTester tester) async {
      final pastDate = DateTime(2020, 1, 1);
      final futureDate = DateTime(2030, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () => Utils.pickDate(context, pastDate),
                  child: const Text('Pick Past Date'),
                ),
                ElevatedButton(
                  onPressed: () => Utils.pickDate(context, futureDate),
                  child: const Text('Pick Future Date'),
                ),
              ],
            ),
          ),
        ),
      );

      // Test past date (should use current date as initial)
      await tester.tap(find.text('Pick Past Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      // Test future date
      await tester.tap(find.text('Pick Future Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('should handle time picker 24h format',
        (WidgetTester tester) async {
      const time = TimeOfDay(hour: 14, minute: 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.pickTime(context, time, true),
              child: const Text('Pick Time 24h'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick Time 24h'));
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });
  });
}
