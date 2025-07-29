import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // eg. access config variable ${AppConfig().environment}
  static Future<void> init({required String envFile}) async {
    await dotenv.load(fileName: envFile);
  }

  static String get appName => dotenv.env['APP_NAME'] ?? 'MyApp';

  static String get googlePlacesApiKey =>
      dotenv.env['API_GOOGLE_PLACES_KEY'] ?? '';

  static String get apiUrl =>
      dotenv.env['API_URL'] ?? "https://api.api-visa.trantorinc.com/v1";

  static String get weburl =>
      dotenv.env['WEB_URL'] ?? "https://api.api-visa.trantorinc.com/v1";

  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://myapp.com';

  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  static String get awsApiGatewayEnvironment =>
      dotenv.env['AWS_API_GATEWAY_ENVIRONMENT'] ?? 'development';

  static bool get isDevelopment => environment == 'development';

  static bool get isProduction => environment == 'production';

  static String get firebaseAndroidKey =>
      dotenv.env['FIREBASE_ANDROID_KEY'] ?? '';

  static String get firebaseIosKey => dotenv.env['FIREBASE_IOS_KEY'] ?? '';

  static String get firebaseWebKey => dotenv.env['FIREBASE_WEB_KEY'] ?? '';
}
