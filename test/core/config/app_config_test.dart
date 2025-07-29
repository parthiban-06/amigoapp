import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/core/config/app_config.dart';

void main() {
  group('AppConfig Tests', () {
    group('Singleton Pattern', () {
      test('should implement singleton pattern correctly', () {
        final instance1 = AppConfig();
        final instance2 = AppConfig();

        expect(identical(instance1, instance2), isTrue);
        expect(instance1, equals(instance2));
      });

      test('should have consistent instance properties', () {
        final config = AppConfig();

        expect(config.appName, isA<String>());
        expect(config.apiUrl, isA<String>());
        expect(config.baseUrl, isA<String>());
        expect(config.environment, isA<String>());
        expect(config.awsApiGatewayEnvironment, isA<String>());
      });
    });

    group('Configuration Properties', () {
      test('should have valid configuration values', () {
        final config = AppConfig();

        expect(config.appName, isNotEmpty);
        expect(config.apiUrl, isNotEmpty);
        expect(config.baseUrl, isNotEmpty);
        expect(config.environment, isNotEmpty);
        expect(config.awsApiGatewayEnvironment, isNotEmpty);
      });

      test('should have default configuration values', () {
        final config = AppConfig();

        // Test default values (these come from EnvConfig defaults)
        expect(config.appName, equals('MyApp'));
        expect(config.apiUrl, equals('https://api.api-visa.trantorinc.com/v1'));
        expect(config.baseUrl, equals('https://myapp.com'));
        expect(config.environment, equals('development'));
        expect(config.awsApiGatewayEnvironment, equals('development'));
      });
    });

    group('Environment Detection', () {
      test('should correctly detect development environment', () {
        expect(AppConfig.isDevelopment, isTrue);
        expect(AppConfig.isProduction, isFalse);
      });

      test('should have consistent environment logic', () {
        final isDev = AppConfig.isDevelopment;
        final isProd = AppConfig.isProduction;

        // Test that environment flags are consistent
        expect(isDev, isNot(equals(isProd)));
        expect(isDev || isProd, isTrue);
      });
    });

    group('Static Methods', () {
      test('should have init method', () {
        expect(AppConfig.init, isA<Function>());
      });

      test('should have environment getters', () {
        expect(AppConfig.isDevelopment, isA<bool>());
        expect(AppConfig.isProduction, isA<bool>());
      });
    });

    group('Configuration Consistency', () {
      test('should have consistent configuration structure', () {
        final config = AppConfig();

        // Test that all properties are accessible and have correct types
        expect(() => config.appName, returnsNormally);
        expect(() => config.apiUrl, returnsNormally);
        expect(() => config.baseUrl, returnsNormally);
        expect(() => config.environment, returnsNormally);
        expect(() => config.awsApiGatewayEnvironment, returnsNormally);
      });

      test('should have non-null configuration values', () {
        final config = AppConfig();

        expect(config.appName, isNotNull);
        expect(config.apiUrl, isNotNull);
        expect(config.baseUrl, isNotNull);
        expect(config.environment, isNotNull);
        expect(config.awsApiGatewayEnvironment, isNotNull);
      });
    });

    group('URL Validation', () {
      test('should have valid URL formats', () {
        final config = AppConfig();

        expect(config.apiUrl.contains('://'), isTrue);
        expect(config.baseUrl.contains('://'), isTrue);
        expect(config.apiUrl.split('://').length, equals(2));
        expect(config.baseUrl.split('://').length, equals(2));
      });

      test('should have secure URLs', () {
        final config = AppConfig();

        expect(config.apiUrl.startsWith('https://'), isTrue);
        expect(config.baseUrl.startsWith('https://'), isTrue);
      });
    });

    group('Environment Enum', () {
      test('should have correct environment enum values', () {
        expect(Environment.dev, equals(Environment.dev));
        expect(Environment.prod, equals(Environment.prod));
        expect(Environment.dev, isNot(equals(Environment.prod)));
      });

      test('should have valid environment enum structure', () {
        expect(Environment.values, contains(Environment.dev));
        expect(Environment.values, contains(Environment.prod));
        expect(Environment.values.length, equals(2));
      });
    });

    group('Integration with EnvConfig', () {
      test('should use EnvConfig values correctly', () {
        final config = AppConfig();

        // Test that AppConfig uses EnvConfig values
        expect(config.appName, equals('MyApp')); // From EnvConfig default
        expect(
            config.apiUrl,
            equals(
                'https://api.api-visa.trantorinc.com/v1')); // From EnvConfig default
        expect(config.baseUrl,
            equals('https://myapp.com')); // From EnvConfig default
        expect(config.environment,
            equals('development')); // From EnvConfig default
        expect(config.awsApiGatewayEnvironment,
            equals('development')); // From EnvConfig default
      });

      test('should have consistent environment flags with EnvConfig', () {
        expect(AppConfig.isDevelopment, isTrue); // Should match EnvConfig
        expect(AppConfig.isProduction, isFalse); // Should match EnvConfig
      });
    });

    group('Edge Cases', () {
      test('should handle configuration access consistently', () {
        final config1 = AppConfig();
        final config2 = AppConfig();

        // Test that multiple instances have the same values
        expect(config1.appName, equals(config2.appName));
        expect(config1.apiUrl, equals(config2.apiUrl));
        expect(config1.baseUrl, equals(config2.baseUrl));
        expect(config1.environment, equals(config2.environment));
        expect(config1.awsApiGatewayEnvironment,
            equals(config2.awsApiGatewayEnvironment));
      });

      test('should maintain singleton behavior under stress', () {
        final instances = <AppConfig>[];

        // Create multiple instances
        for (int i = 0; i < 10; i++) {
          instances.add(AppConfig());
        }

        // All instances should be identical
        for (int i = 1; i < instances.length; i++) {
          expect(identical(instances[0], instances[i]), isTrue);
        }
      });
    });

    group('Configuration Validation', () {
      test('should have valid app name format', () {
        final config = AppConfig();

        expect(config.appName, isNotEmpty);
        expect(config.appName.length, greaterThan(0));
        expect(config.appName, isA<String>());
      });

      test('should have valid environment name format', () {
        final config = AppConfig();

        expect(config.environment, isNotEmpty);
        expect(config.environment, isA<String>());
        expect(['development', 'production'], contains(config.environment));
      });

      test('should have valid AWS environment name format', () {
        final config = AppConfig();

        expect(config.awsApiGatewayEnvironment, isNotEmpty);
        expect(config.awsApiGatewayEnvironment, isA<String>());
      });
    });
  });
}
