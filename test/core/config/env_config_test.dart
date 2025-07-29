import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/core/config/env_config.dart';

void main() {
  group('EnvConfig Tests', () {
    group('Initialization', () {
      test('should initialize with default values when env file is not loaded',
          () {
        // Test default values when dotenv is not initialized
        expect(EnvConfig.appName, equals('MyApp'));
        expect(EnvConfig.googlePlacesApiKey, equals(''));
        expect(
            EnvConfig.apiUrl, equals('https://api.api-visa.trantorinc.com/v1'));
        expect(EnvConfig.baseUrl, equals('https://myapp.com'));
        expect(EnvConfig.environment, equals('development'));
        expect(EnvConfig.awsApiGatewayEnvironment, equals('development'));
        expect(EnvConfig.firebaseAndroidKey, equals(''));
        expect(EnvConfig.firebaseIosKey, equals(''));
        expect(EnvConfig.firebaseWebKey, equals(''));
      });

      test('should have correct environment flags', () {
        // Test environment flags
        expect(EnvConfig.isDevelopment, isTrue);
        expect(EnvConfig.isProduction, isFalse);
      });
    });

    group('Environment Detection', () {
      test('should correctly detect development environment', () {
        // Since default environment is 'development'
        expect(EnvConfig.environment, equals('development'));
        expect(EnvConfig.isDevelopment, isTrue);
        expect(EnvConfig.isProduction, isFalse);
      });

      test('should have consistent environment logic', () {
        // Test that environment logic is consistent
        final env = EnvConfig.environment;
        expect(EnvConfig.isDevelopment, equals(env == 'development'));
        expect(EnvConfig.isProduction, equals(env == 'production'));
      });
    });

    group('API Configuration', () {
      test('should have valid API URL format', () {
        final apiUrl = EnvConfig.apiUrl;
        expect(apiUrl, isNotEmpty);
        expect(apiUrl.startsWith('http'), isTrue);
        expect(apiUrl.contains('api'), isTrue);
      });

      test('should have valid base URL format', () {
        final baseUrl = EnvConfig.baseUrl;
        expect(baseUrl, isNotEmpty);
        expect(baseUrl.startsWith('http'), isTrue);
      });

      test('should have valid AWS API Gateway environment', () {
        final awsEnv = EnvConfig.awsApiGatewayEnvironment;
        expect(awsEnv, isNotEmpty);
        expect(awsEnv, equals('development')); // Default value
      });
    });

    group('Firebase Configuration', () {
      test('should have Firebase configuration properties', () {
        // Test that Firebase properties exist and are strings
        expect(EnvConfig.firebaseAndroidKey, isA<String>());
        expect(EnvConfig.firebaseIosKey, isA<String>());
        expect(EnvConfig.firebaseWebKey, isA<String>());
      });

      test('should have empty Firebase keys by default', () {
        // Test default empty values
        expect(EnvConfig.firebaseAndroidKey, equals(''));
        expect(EnvConfig.firebaseIosKey, equals(''));
        expect(EnvConfig.firebaseWebKey, equals(''));
      });
    });

    group('Google Places API', () {
      test('should have Google Places API key property', () {
        expect(EnvConfig.googlePlacesApiKey, isA<String>());
      });

      test('should have empty Google Places API key by default', () {
        expect(EnvConfig.googlePlacesApiKey, equals(''));
      });
    });

    group('App Configuration', () {
      test('should have app name property', () {
        expect(EnvConfig.appName, isA<String>());
        expect(EnvConfig.appName, isNotEmpty);
      });

      test('should have default app name', () {
        expect(EnvConfig.appName, equals('MyApp'));
      });
    });

    group('Configuration Validation', () {
      test('should have consistent configuration structure', () {
        // Test that all configuration properties are accessible
        expect(() => EnvConfig.appName, returnsNormally);
        expect(() => EnvConfig.apiUrl, returnsNormally);
        expect(() => EnvConfig.baseUrl, returnsNormally);
        expect(() => EnvConfig.environment, returnsNormally);
        expect(() => EnvConfig.awsApiGatewayEnvironment, returnsNormally);
        expect(() => EnvConfig.isDevelopment, returnsNormally);
        expect(() => EnvConfig.isProduction, returnsNormally);
        expect(() => EnvConfig.googlePlacesApiKey, returnsNormally);
        expect(() => EnvConfig.firebaseAndroidKey, returnsNormally);
        expect(() => EnvConfig.firebaseIosKey, returnsNormally);
        expect(() => EnvConfig.firebaseWebKey, returnsNormally);
      });

      test('should have non-null configuration values', () {
        // Test that all configuration values are not null
        expect(EnvConfig.appName, isNotNull);
        expect(EnvConfig.apiUrl, isNotNull);
        expect(EnvConfig.baseUrl, isNotNull);
        expect(EnvConfig.environment, isNotNull);
        expect(EnvConfig.awsApiGatewayEnvironment, isNotNull);
        expect(EnvConfig.googlePlacesApiKey, isNotNull);
        expect(EnvConfig.firebaseAndroidKey, isNotNull);
        expect(EnvConfig.firebaseIosKey, isNotNull);
        expect(EnvConfig.firebaseWebKey, isNotNull);
      });
    });

    group('URL Validation', () {
      test('should have valid URL formats', () {
        final apiUrl = EnvConfig.apiUrl;
        final baseUrl = EnvConfig.baseUrl;

        // Test URL format validation
        expect(apiUrl.contains('://'), isTrue);
        expect(baseUrl.contains('://'), isTrue);
        expect(apiUrl.split('://').length, equals(2));
        expect(baseUrl.split('://').length, equals(2));
      });

      test('should have secure URLs by default', () {
        final apiUrl = EnvConfig.apiUrl;
        final baseUrl = EnvConfig.baseUrl;

        // Test that default URLs use HTTPS
        expect(apiUrl.startsWith('https://'), isTrue);
        expect(baseUrl.startsWith('https://'), isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle missing environment variables gracefully', () {
        // Test that the class handles missing env variables gracefully
        // by providing default values
        expect(EnvConfig.appName, isNotEmpty);
        expect(EnvConfig.apiUrl, isNotEmpty);
        expect(EnvConfig.baseUrl, isNotEmpty);
        expect(EnvConfig.environment, isNotEmpty);
        expect(EnvConfig.awsApiGatewayEnvironment, isNotEmpty);
      });

      test('should have consistent boolean environment flags', () {
        // Test that environment flags are mutually exclusive
        final isDev = EnvConfig.isDevelopment;
        final isProd = EnvConfig.isProduction;

        // They should not both be true at the same time
        expect(isDev && isProd, isFalse);

        // At least one should be true (in this case, dev should be true)
        expect(isDev || isProd, isTrue);
      });
    });
  });
}
