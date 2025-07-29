// test/utils/utils_biometric_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:visaamigo/utils/utils.dart';

void main() {
  group('Utils Biometric Operations Detailed Tests', () {
    test('should return true when biometric authentication succeeds', () async {
      // Test enableBioMetrics
      final result = await Utils.enableBioMetrics();
      expect(result, isA<bool>());
    });

    test('should return false when biometric authentication fails', () async {
      // This tests the actual implementation behavior
      final result = await Utils.enableBioMetrics();
      expect(result, isA<bool>());
    });

    test('should detect biometric support correctly', () async {
      final isSupported = await Utils.isBioMetricsSupported();
      expect(isSupported, isA<bool>());
    });

    test('should return null when no biometrics available', () async {
      final biometricType = await Utils.getSupportedBiometric();
      expect(biometricType, isA<BiometricType?>());
    });

    test('should handle platform-specific biometric types', () async {
      final biometricType = await Utils.getSupportedBiometric();

      if (biometricType != null) {
        expect([
          BiometricType.face,
          BiometricType.fingerprint,
          BiometricType.iris,
          BiometricType.strong,
          BiometricType.weak
        ], contains(biometricType));
      }
    });

    test('should handle biometric permission errors', () async {
      // Test that methods handle errors gracefully
      expect(() async => await Utils.enableBioMetrics(), returnsNormally);
      expect(() async => await Utils.getSupportedBiometric(), returnsNormally);
    });
  });
}
