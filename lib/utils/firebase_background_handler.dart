import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../custom_widgets/visa_snack_bar.dart';

class FirebaseNotificationHandler {
  String fcmToken = '';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final FirebaseNotificationHandler _instance =
      FirebaseNotificationHandler._internal();

  factory FirebaseNotificationHandler() => _instance;

  FirebaseNotificationHandler._internal();

  BuildContext? context;

  Future<void> initializeFirebaseMessaging(BuildContext context) async {
    try {
      this.context = context;
      Utils.logPrint("🚀 Starting Firebase messaging initialization...");

      if (kIsWeb) {
        return;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request Firebase notification permissions
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        criticalAlert: false,
        announcement: false,
      );

      Utils.logPrint(
          "🚀 FirebaseMessaging notificationStatus: ${settings.authorizationStatus}");
      Utils.logPrint("🚀 FirebaseMessaging alert: ${settings.alert}");
      Utils.logPrint("🚀 FirebaseMessaging badge: ${settings.badge}");
      Utils.logPrint("🚀 FirebaseMessaging sound: ${settings.sound}");

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        Utils.logPrint(
            "🚀 Notification permission granted, setting up messaging...");

        // Get FCM token
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          fcmToken = token;
          Utils.logPrint("🚀 FCM Token: $fcmToken");
        } else {
          Utils.logPrint("⚠️ FCM Token is null");
        }

        // Set up message handlers
        _setupMessageHandlers();

        // Set up token refresh listener
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          fcmToken = newToken;
          Utils.logPrint("🚀 FCM Token refreshed: $fcmToken");
        });

        Utils.logPrint("✅ Firebase messaging setup completed successfully");
      } else {
        Preferences.setBool(Preferences.isNotificationPermissionEnable, false);
        Utils.logPrint(
            "🔕 FirebaseMessaging Skipping push listener setup: Notification permission denied");
        Utils.logPrint(
            "🔕 Authorization status: ${settings.authorizationStatus}");
      }
    } catch (e) {
      Utils.logPrint(
          '❌ FirebaseMessaging Error initializing Firebase messaging: $e');
      Utils.logPrint(
          '❌ FirebaseMessaging Error stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    try {
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

      await flutterLocalNotificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          Utils.logPrint('Local notification tapped: ${response.payload}');
          // Handle local notification tap
          _handleLocalNotificationTap(response);
        },
      );

      Utils.logPrint("✅ Local notifications initialized successfully");
    } catch (e) {
      Utils.logPrint("❌ Error initializing local notifications: $e");
    }
  }

  void _setupMessageHandlers() {
    Utils.logPrint(
        "🚀FirebaseMessaging  Setting up Firebase message handlers...");

    // When app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Utils.logPrint(
          '🚀 FirebaseMessaging.onMessage received: ${message.notification?.title}');
      Utils.logPrint('🚀 Message data: ${message.data}');
      Utils.logPrint('🚀 Message notification: ${message.notification?.body}');
      Utils.logPrint('🚀 Message from: ${message.from}');
      Utils.logPrint('🚀 Message messageId: ${message.messageId}');
      Utils.logPrint('🚀 Message sentTime: ${message.sentTime}');
      Utils.logPrint('🚀 Message ttl: ${message.ttl}');

      // Don't show local notification when app is in foreground
      // The notification data will be handled by the iOS delegate and sent via method channel
      // if (message.notification != null) {
      //   _showLocalNotification(message);
      // }

      // Show snackbar for immediate user feedback
      if (context != null) {
        visaSnackBar(
          context: context,
          type: SnackBarType.success,
          title: message.notification?.title,
          subtitle: message.notification?.body,
          showAtBottom: true,
        );
// show realtime notification count update
        // Provider.of<UserGenericProvider>(context!, listen: false)
        //     .markNotificationUnRead();
      }
    }, onError: (error) {
      Utils.logPrint('❌FirebaseMessaging  Error in onMessage listener: $error');
    });

    // When app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.logPrint(
          '🚀 FirebaseMessaging Notification opened the app: ${message.notification?.title}');
      Utils.logPrint('🚀 FirebaseMessaging Message data: ${message.data}');

      // Handle navigation or other actions based on message data
      _handleNotificationTap(message);
    }, onError: (error) {
      Utils.logPrint('❌ Error in onMessageOpenedApp listener: $error');
    });

    // Check for initial message when app is opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Utils.logPrint(
            '💡 FirebaseMessaging App opened from terminated: ${message.notification?.title}');
        Utils.logPrint('💡 Message data: ${message.data}');

        // Handle navigation or other actions based on message data
        _handleNotificationTap(message);
      } else {
        Utils.logPrint('💡FirebaseMessaging No initial message found');
      }
    }).catchError((error) {
      Utils.logPrint(
          '❌ FirebaseMessaging Error getting initial message: $error');
    });

    Utils.logPrint(
        "✅ FirebaseMessaging Firebase message handlers setup completed");
  }

  void _showLocalNotification(RemoteMessage message) async {
    try {
      final notificationId =
          message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch;

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Firebase Notifications',
            channelDescription:
                'This channel is used for important notifications.',
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
      );

      Utils.logPrint(
          '✅ Local notification shown successfully for: ${message.notification?.title}');
    } catch (e) {
      Utils.logPrint('❌ Error showing local notification: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Handle navigation or other actions based on message data
    // You can add your navigation logic here
    Utils.logPrint(
        'Handling notification tap for: ${message.notification?.title}');

    // Example: Navigate based on message data
    if (message.data.containsKey('screen')) {
      String screen = message.data['screen'];
      Utils.logPrint('Navigate to screen: $screen');
      // Add your navigation logic here
    }
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    Utils.logPrint(
        'Local notification tapped with payload: ${response.payload}');
    // Handle local notification tap
    // You can add your navigation logic here
  }

  void showNotification(String title, String body) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel', // Channel ID
            'Firebase Notifications',

            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            visibility: NotificationVisibility.public,
            playSound: true,
            enableVibration: true,
            // Ensure it's public
            icon: '@mipmap/ic_icon',
          ),
          iOS: DarwinNotificationDetails()),
    );
  }
}
