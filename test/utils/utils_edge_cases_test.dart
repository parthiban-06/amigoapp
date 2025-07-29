// test/utils/utils_edge_cases_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/utils/utils.dart';

void main() {
  group('Utils Edge Cases and Boundary Tests', () {
    test('should handle boundary values in hex color conversion', () {
      // Test minimum hex values
      expect(Utils.getColorFromHex('000000'), 0xFF000000);

      // Test maximum hex values
      expect(Utils.getColorFromHex('FFFFFF'), 0xFFFFFFFF);

      // Test with alpha channel
      expect(Utils.getColorFromHex('80FFFFFF'), 0x80FFFFFF);
    });

    test('should handle extreme font sizes in scaling', () {
      // Test very small font size
      expect(Utils.getMaxScale(1), 2.0);

      // Test very large font size
      expect(Utils.getMaxScale(100), 1.3);

      // Test zero font size
      expect(Utils.getMaxScale(0), 2.0);

      // Test negative font size
      expect(Utils.getMaxScale(-5), 2.0);
    });

    test('should handle malformed currency strings', () {
      // Test with letters
      expect(Utils.formatUsd('abc'), 'abc');

      // Test with special characters
      // expect(Utils.formatUsd(''), '100');

      // Test with multiple decimal points
      expect(Utils.formatUsd('100.50.25'), '100.50.25');

      // Test with very large numbers
      expect(Utils.formatUsd('999999999999.99'), contains('\$'));
    });

    test('should handle extreme coordinates in maps URL', () {
      // Test maximum latitude/longitude
      final maxUrl = Utils.openMaps(90.0, 180.0);
      expect(maxUrl, contains('90.0,180.0'));

      // Test minimum latitude/longitude
      final minUrl = Utils.openMaps(-90.0, -180.0);
      expect(minUrl, contains('-90.0,-180.0'));

      // Test very precise coordinates
      final preciseUrl = Utils.openMaps(37.7749295, -122.4194155);
      expect(preciseUrl, contains('37.7749295'));
    });

    test('should handle very long strings in UTF-8 conversion', () {
      // Test with long string
      final longString = 'Hello\\x20' * 1000;
      final result = Utils.convrtStringUtf(longString);
      expect(result, isA<String>());

      // Test with no escape sequences
      const normalString = 'Hello World No Escapes';
      final normalResult = Utils.convrtStringUtf(normalString);
      expect(normalResult, isA<String>());
    });

    test('should handle complex URLs in domain extraction', () {
      // Test with port numbers
      expect(
          Utils.getDomainName('https://example.com:8080/path'), 'example.com');

      // Test with IP addresses
      expect(Utils.getDomainName('http://192.168.1.1/path'), '192.168.1.1');

      // Test with internationalized domain names
      expect(() => Utils.getDomainName('https://例え.テスト'), returnsNormally);
    });

    test('should handle timezone extraction edge cases', () {
      // Test input without timezone
      const noTimezone = '2024-01-01T10:00:00';
      final match = RegExp(r'([+-]\d{2}:\d{2})').firstMatch(noTimezone);
      expect(match, isNull);

      // Test with multiple timezone patterns
      const multipleTimezones = '2024-01-01T10:00:00+05:30 and +02:00';
      final firstMatch =
          RegExp(r'([+-]\d{2}:\d{2})').firstMatch(multipleTimezones);
      expect(firstMatch?.group(1), '+05:30');
    });

    test('should handle number formatting with extreme locales', () {
      // Test with empty locale
      expect(() => Utils.formatNumber(1000, ''), throwsA(isA<Exception>()));

      // Test with very long locale string
      final longLocale = 'en_' + 'US' * 100;
      final result = Utils.formatNumber(1000, longLocale);
      expect(result, contains('Error'));
    });

    test('should handle hex encoding with empty and null strings', () {
      // Test with empty string
      expect(Utils.encodeHexString(''), isEmpty);

      // Test with null
      expect(Utils.encodeHexString(null), isEmpty);

      // Test with whitespace only
      final whitespaceResult = Utils.encodeHexString('   ');
      expect(whitespaceResult, contains('\\x'));
    });
  });
}
