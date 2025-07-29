import '../../utils/utils.dart';
import 'env_config.dart';

enum Environment { dev, prod }

class AppConfig {
  final String appName;
  final String apiUrl;
  final String baseUrl;
  final String environment;
  final String awsApiGatewayEnvironment;

  AppConfig._internal()
      : appName = EnvConfig.appName,
        apiUrl = EnvConfig.apiUrl,
        baseUrl = EnvConfig.baseUrl,
        environment = EnvConfig.environment,
        awsApiGatewayEnvironment = EnvConfig.awsApiGatewayEnvironment;

  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  static Future<void> init({required String envFile}) async {
    Utils.logPrint("envFile $envFile");
    await EnvConfig.init(envFile: envFile);
  }

  static bool get isDevelopment => EnvConfig.isDevelopment;

  static bool get isProduction => EnvConfig.isProduction;
}
