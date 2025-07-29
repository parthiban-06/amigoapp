import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/core/config/app_config.dart';
import 'package:visaamigo/di/service_locator.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/firebase_options.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/encrypt_decrypt_service.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/startup_performance.dart';
import 'package:visaamigo/utils/utils.dart';

/// Environment configuration enum
enum AppEnvironment {
  dev('config/dev/.env'),
  qa('config/qa/.env'),
  prod('config/prod/.env'),
  visaDev('config/visa_dev/.env');

  const AppEnvironment(this.envPath);

  final String envPath;
}

// Lightweight background message handler for immediate registration
@pragma('vm:entry-point')
Future<void> lightweightBackgroundHandler(RemoteMessage message) async {
  // Minimal processing - just log and return
  Utils.logPrint('💡Lightweight background message: ${message.messageId}');

  // Store message for later processing if needed
  // This prevents message loss while app is starting up
}

// Top-level background message handler - optimized for faster startup
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Minimal logging for faster execution
  Utils.logPrint('💡Background message received: ${message.messageId}');

  // Only process if there's actual notification content
  if (message.notification == null) {
    Utils.logPrint('💡No notification content, skipping processing');
    return;
  }

  try {
    // Defer heavy initialization to avoid blocking startup
    _processBackgroundNotification(message);
  } catch (e) {
    Utils.logPrint('❌ Background notification error: $e');
  }
}

// Separate function to handle the heavy notification processing
Future<void> _processBackgroundNotification(RemoteMessage message) async {
  try {
    // Initialize local notifications only when needed
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Minimal initialization settings for faster startup
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      iOS: iosSettings,
      android: androidSettings,
    );

    // Initialize with shorter timeout
    await flutterLocalNotificationsPlugin
        .initialize(settings)
        .timeout(const Duration(seconds: 3));

    // Show notification with minimal configuration
    await flutterLocalNotificationsPlugin
        .show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Firebase Notifications',
              channelDescription: 'Important notifications',
              importance: Importance.high,
              priority: Priority.high,
              visibility: NotificationVisibility.public,
              playSound: true,
              enableVibration: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 1,
            ),
          ),
          payload: message.data.toString(),
        )
        .timeout(const Duration(seconds: 2));

    Utils.logPrint('✅ Background notification processed successfully');
  } catch (e) {
    Utils.logPrint('❌ Error processing background notification: $e');
  }
}

/// Common app initialization logic
class AppInitializer {
  static AppEnvironment _currentEnvironment = AppEnvironment.dev;

  /// Initialize the app with the specified environment
  static Future<void> initialize(AppEnvironment environment) async {
    StartupPerformance.markMilestone('app_initialization_start');
    _currentEnvironment = environment;

    // Ensure Flutter binding is initialized

    // Setup service locator
    StartupPerformance.markMilestone('service_locator_setup_start');
    setupServiceLocator();
    StartupPerformance.markMilestone('service_locator_setup_end');

    // Initialize app configuration
    StartupPerformance.markMilestone('app_config_start');
    await _initializeAppConfig();
    StartupPerformance.markMilestone('app_config_end');

    // Initialize Firebase
    StartupPerformance.markMilestone('firebase_init_start');
    await _initializeFirebase();
    StartupPerformance.markMilestone('firebase_init_end');

    // Setup app configurations
    StartupPerformance.markMilestone('app_configurations_start');
    await _setupAppConfigurations();
    StartupPerformance.markMilestone('app_configurations_end');

    // Initialize analytics
    StartupPerformance.markMilestone('analytics_init_start');
    _initializeAnalytics();
    StartupPerformance.markMilestone('analytics_init_end');

    // Setup system preferences
    StartupPerformance.markMilestone('system_preferences_start');
    _setupSystemPreferences();
    StartupPerformance.markMilestone('system_preferences_end');

    StartupPerformance.markMilestone('app_initialization_end');
    StartupPerformance.logStartupSummary();
  }

  /// Initialize app configuration based on environment
  static Future<void> _initializeAppConfig() async {
    await AppConfig.init(envFile: _currentEnvironment.envPath);
    await Utils.getAppVersion();
    DateUtil.initializeTimezones();
  }

  /// Initialize Firebase services
  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Register lightweight background handler immediately to prevent message loss
    FirebaseMessaging.onBackgroundMessage(lightweightBackgroundHandler);

    // Enable Crashlytics for non-web platforms
    if (!kIsWeb) {
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      // FlutterError.onError =
      //     FirebaseCrashlytics.instance.recordFlutterFatalError;

      // FlutterError.onError = (errorDetails) {
      //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };
    }
  }

  /// Register Firebase background message handler - called after app is ready
  static void registerBackgroundMessageHandler() {
    // Register full background message handler after app initialization is complete
    // Note: Firebase only allows one background handler, so we replace the lightweight one
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    Utils.logPrint('✅ Firebase full background message handler registered');
  }

  /// Setup app configurations
  static Future<void> _setupAppConfigurations() async {
    // Set URL strategy for web
    setPathUrlStrategy();

    // Initialize app config
    await _configureAppServices();
  }

  /// Configure app services (Preferences, Amplify, Analytics)
  static Future<void> _configureAppServices() async {
    // Initialize encrypted shared preferences
    await EncryptedSharedPreferences.initialize(
      dotenv.env[AppConst.AES_ENC_KEY]!,
      encryptor: CustomEncryptorAlgorithm(),
    );

    // Initialize regular preferences
    await Preferences.init();

    // Configure Amplify
    final amplifyService = AmplifyService();
    await amplifyService.configureAmplify();

    // Setup Firebase Analytics Service
    await _setupFirebaseAnalyticsService();

    // Setup user analytics ID
    await _setupUserAnalyticsId();
  }

  /// Setup Firebase Analytics Service with device info
  static Future<void> _setupFirebaseAnalyticsService() async {
    bool? analyticsTracking =
        await Preferences.getBoolWithNull(Preferences.keyAnalyticsTracking);

    FirebaseAnalyticsService.setAnalyticsEnableStatus(
        analyticsTracking ?? false);
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        FirebaseAnalyticsService.androidInfo =
            await DeviceInfoPlugin().androidInfo;
        // FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
      } else if (Platform.isIOS) {
        FirebaseAnalyticsService.iosInfo = await DeviceInfoPlugin().iosInfo;
        // FirebaseAnalyticsService.setAnalyticsEnableStatus(
        //     await Preferences.getBool(Preferences.keyAnalyticsTracking));
      }
    }
  }

  /// Setup user analytics ID from stored user model
  static Future<void> _setupUserAnalyticsId() async {
    try {
      FirebaseAnalyticsService.packageInfo = await PackageInfo.fromPlatform();

      UserModel? userModel = await Preferences.getModelData(
        Preferences.KeyUserModel,
        UserModel.fromJson,
      );

      if (userModel != null && userModel.userAnalyticsId.isNotEmpty) {
        FirebaseAnalyticsService.userAnalyticsId = userModel.userAnalyticsId;
      }
    } catch (e) {
      // Log error but don't crash the app initialization
      Utils.logPrint('❌ Error setting up user analytics ID: $e');
      // Continue with app initialization even if user model parsing fails
    }
  }

  /// Initialize analytics
  static void _initializeAnalytics() {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    AppRouter.initializeAnalytics(analytics);
  }

  /// Setup system preferences
  static void _setupSystemPreferences() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    GoRouter.optionURLReflectsImperativeAPIs = true;
  }

  /// Get current environment
  static AppEnvironment get currentEnvironment => _currentEnvironment;

  /// Check if current environment is development
  static bool get isDevelopment => _currentEnvironment == AppEnvironment.dev;

  /// Check if current environment is QA
  static bool get isQA => _currentEnvironment == AppEnvironment.qa;

  /// Check if current environment is production
  static bool get isProduction => _currentEnvironment == AppEnvironment.prod;
}
