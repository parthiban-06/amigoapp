import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
//     UserDefaults.standard.set(true, forKey: "FIRDebugEnabled")
    FirebaseApp.configure()

    // Set up push notifications for iOS 16.6+
    if #available(iOS 16.6, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .providesAppNotificationSettings]

      Task {
        do {
          let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
          if granted {
            await MainActor.run {
              application.registerForRemoteNotifications()
            }
          }
        } catch {
          print("Notification authorization error: \(error)")
        }
      }
    } else {
      // For iOS versions below 16.6, use the traditional approach
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
      application.registerForRemoteNotifications()
    }

    // Set FCM messaging delegate
    Messaging.messaging().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    // Original launchUrl channel
    let launchUrlChannel = FlutterMethodChannel(name: "launchUrl", binaryMessenger: controller.binaryMessenger)
    launchUrlChannel.setMethodCallHandler { (call, result) in
        if call.method == "openUrl" {
            if let url = call.arguments as? String {
                if let url = URL(string: url) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        result(nil)
                    } else {
                        result(FlutterError(code: "UNAVAILABLE", message: "URL cannot be opened", details: nil))
                    }
                } else {
                    result(FlutterError(code: "INVALID_URL", message: "Invalid URL", details: nil))
                }
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing URL argument", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    // Token channel for FCM and APNS tokens (iOS 16.6+)
    let tokenChannel = FlutterMethodChannel(name: "tokenChannel", binaryMessenger: controller.binaryMessenger)
    tokenChannel.setMethodCallHandler { (call, result) in
      if call.method == "getFCMToken" {
        if #available(iOS 16.6, *) {
          Task {
            do {
              let token = try await Messaging.messaging().token()
              await MainActor.run {
                result(token)
              }
            } catch {
              await MainActor.run {
                result(FlutterError(code: "TOKEN_ERROR", message: "Error fetching FCM token", details: error.localizedDescription))
              }
            }
          }
        } else {
          // Fallback for older iOS versions
          Messaging.messaging().token { token, error in
            if let error = error {
              result(FlutterError(code: "TOKEN_ERROR", message: "Error fetching FCM token", details: error.localizedDescription))
            } else {
              result(token)
            }
          }
        }
      } else if call.method == "getAPNSToken" {
        if #available(iOS 16.6, *) {
          // First try to get from Messaging
          if let apnsToken = Messaging.messaging().apnsToken {
            let tokenString = apnsToken.map { String(format: "%02.2hhx", $0) }.joined()
            result(tokenString)
          } else {
            // If not available, try to register again
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
            result(FlutterError(code: "APNS_TOKEN_UNAVAILABLE", message: "APNS token not available. Requesting registration...", details: nil))
          }
        } else {
          // Fallback for older iOS versions
          if let apnsToken = Messaging.messaging().apnsToken {
            let tokenString = apnsToken.map { String(format: "%02.2hhx", $0) }.joined()
            result(tokenString)
          } else {
            result(FlutterError(code: "APNS_TOKEN_UNAVAILABLE", message: "APNS token not available", details: nil))
          }
        }
      } else if call.method == "getNotificationSettings" {
        if #available(iOS 16.6, *) {
          Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            let settingsDict: [String: Any] = [
              "authorizationStatus": settings.authorizationStatus.rawValue,
              "alertSetting": settings.alertSetting.rawValue,
              "badgeSetting": settings.badgeSetting.rawValue,
              "soundSetting": settings.soundSetting.rawValue,
              "providesAppNotificationSettings": settings.providesAppNotificationSettings,
              "criticalAlertSetting": settings.criticalAlertSetting.rawValue,
              "announcementSetting": settings.announcementSetting.rawValue,
              "scheduledDeliverySetting": settings.scheduledDeliverySetting.rawValue
            ]
            await MainActor.run {
              result(settingsDict)
            }
          }
        } else {
          // Fallback for older iOS versions
          UNUserNotificationCenter.current().getNotificationSettings { settings in
            let settingsDict: [String: Any] = [
              "authorizationStatus": settings.authorizationStatus.rawValue,
              "alertSetting": settings.alertSetting.rawValue,
              "badgeSetting": settings.badgeSetting.rawValue,
              "soundSetting": settings.soundSetting.rawValue
            ]
            result(settingsDict)
          }
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // Device Security Channel
    let securityChannel = FlutterMethodChannel(name: "device_security_channel", binaryMessenger: controller.binaryMessenger)
    securityChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      switch call.method {
      case "isDeviceCompromised":
        result(self.isDeviceJailbroken())
      case "isDeveloperModeEnabled":
        result(self.isDeveloperModeEnabled())
      case "performSecurityCheck":
        let isCompromised = self.isDeviceJailbroken()
        let isDeveloperMode = self.isDeveloperModeEnabled()
        let securityResult: [String: Any] = [
          "isCompromised": isCompromised,
          "isDeveloperMode": isDeveloperMode,
          "isSecure": (!isCompromised && !isDeveloperMode),
          "platform": "ios"
        ]
        result(securityResult)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    self.window?.backgroundColor = UIColor.white
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle APNS token registration
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Set APNS token to Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken

    // Convert token to hex string and store for direct access
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("APNS Token received: \(tokenString)")

    // Send APNS token to Flutter
    if let controller = window?.rootViewController as? FlutterViewController {
      let tokenChannel = FlutterMethodChannel(name: "tokenChannel", binaryMessenger: controller.binaryMessenger)
      tokenChannel.invokeMethod("onAPNSTokenReceived", arguments: tokenString)
    }
  }

  // Handle APNS token registration failure
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error.localizedDescription)")
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    // Send token to Flutter side
    if let controller = window?.rootViewController as? FlutterViewController {
      let tokenChannel = FlutterMethodChannel(name: "tokenChannel", binaryMessenger: controller.binaryMessenger)
      tokenChannel.invokeMethod("onFCMTokenReceived", arguments: fcmToken)
    }
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
  // Handle notification presentation when app is in foreground (iOS 10+)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }

    print("Notification received in foreground: \(userInfo)")

    // Convert userInfo to a format Flutter can handle
    var flutterUserInfo: [String: Any] = [:]
    for (key, value) in userInfo {
      if let stringKey = key as? String {
        flutterUserInfo[stringKey] = value
      }
    }

    // Send notification received event to Flutter
    if let controller = window?.rootViewController as? FlutterViewController {
      let tokenChannel = FlutterMethodChannel(name: "tokenChannel", binaryMessenger: controller.binaryMessenger)
      tokenChannel.invokeMethod("onForegroundNotificationReceived", arguments: flutterUserInfo)
      print("Sent foreground notification to Flutter: \(flutterUserInfo)")
    } else {
      print("Failed to get FlutterViewController for foreground notification")
    }

    // Don't show notification banner when app is in foreground
    // Only play sound and update badge if needed
    if #available(iOS 14.0, *) {
      completionHandler([.sound, .badge]) // Removed .banner and .list
    } else {
      completionHandler([.sound, .badge]) // Removed .alert
    }
  }

  // Handle notification tap
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID from notification tap: \(messageID)")
    }

    print("Notification tapped: \(userInfo)")

    // Convert userInfo to a format Flutter can handle
    var flutterUserInfo: [String: Any] = [:]
    for (key, value) in userInfo {
      if let stringKey = key as? String {
        flutterUserInfo[stringKey] = value
      }
    }

    // Send notification tap event to Flutter
    if let controller = window?.rootViewController as? FlutterViewController {
      let tokenChannel = FlutterMethodChannel(name: "tokenChannel", binaryMessenger: controller.binaryMessenger)
      tokenChannel.invokeMethod("onNotificationTapped", arguments: flutterUserInfo)
      print("Sent notification tap to Flutter: \(flutterUserInfo)")
    } else {
      print("Failed to get FlutterViewController for notification tap")
    }

    completionHandler()
  }

  // Handle notification settings button tap (iOS 12+)
  @available(iOS 12.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              openSettingsFor notification: UNNotification?) {
    print("Opening notification settings")

    // Send settings event to Flutter
    if let controller = window?.rootViewController as? FlutterViewController {
      let tokenChannel = FlutterMethodChannel(name: "tokenChannel", binaryMessenger: controller.binaryMessenger)
      tokenChannel.invokeMethod("onNotificationSettingsOpened", arguments: nil)
    }
  }
}

// MARK: - Device Security Methods
extension AppDelegate {
  /**
   * Checks if the device is jailbroken
   * @return true if device is jailbroken, false otherwise
   */
  private func isDeviceJailbroken() -> Bool {
    // Check for common jailbreak indicators
    let jailbreakPaths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/private/var/lib/apt/",
      "/private/var/lib/cydia",
      "/private/var/mobile/Library/SBSettings/Themes",
      "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
      "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
      "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
      "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"
    ]
    
    // Check if any jailbreak indicator exists
    for path in jailbreakPaths {
      if FileManager.default.fileExists(atPath: path) {
        return true
      }
    }
    
    // Check if we can write to system directories
    let systemPaths = [
      "/Applications",
      "/Library",
      "/private",
      "/System",
      "/usr"
    ]
    
    for path in systemPaths {
      if FileManager.default.isWritableFile(atPath: path) {
        return true
      }
    }
    
    // Check for suspicious environment variables
    let suspiciousEnvVars = [
      "DYLD_INSERT_LIBRARIES",
      "DYLD_LIBRARY_PATH"
    ]
    
    for envVar in suspiciousEnvVars {
      if getenv(envVar) != nil {
        return true
      }
    }
    
    return false
  }
  
  /**
   * Checks if developer mode is enabled
   * @return true if developer mode is enabled, false otherwise
   */
  private func isDeveloperModeEnabled() -> Bool {
    // Check if running in debug mode
    #if DEBUG
    return true
    #else
    return false
    #endif
  }
}