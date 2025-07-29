// test/utils/utils_performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/utils/utils.dart';

void main() {
  group('Utils Performance Tests', () {
    test('should handle large-scale hex color conversions efficiently', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        Utils.getColorFromHex('FF${i.toRadixString(16).padLeft(4, '0')}');
      }

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds,
          lessThan(1000)); // Should complete within 1 second
    });

    test('should handle large text scaling calculations efficiently', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 1; i <= 1000; i++) {
        Utils.getMaxScale(i.toDouble());
      }

      stopwatch.stop();
      expect(
          stopwatch.elapsedMilliseconds, lessThan(100)); // Should be very fast
    });

    test('should handle many currency formatting operations efficiently', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        Utils.formatUsd('${i * 1.23}');
      }

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('should handle large string hex encoding efficiently', () {
      final largeString = 'A' * 10000;
      final stopwatch = Stopwatch()..start();

      Utils.encodeHexString(largeString);

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('should handle concurrent operations without interference', () async {
      final futures = List.generate(100, (index) async {
        return Utils.formatUsd('${index * 10.5}');
      });

      final stopwatch = Stopwatch()..start();
      final results = await Future.wait(futures);
      stopwatch.stop();

      expect(results.length, 100);
      expect(results.every((result) => result.contains('\$')), isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}
