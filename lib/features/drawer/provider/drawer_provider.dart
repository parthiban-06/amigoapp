import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

import '../../../token_service.dart';
import '../../../utils/utils.dart';
import '../../profile/provider/user_generic_detail_provider.dart';

class DrawerProvider extends BaseProvider {
  UserGenericProvider? userGenericProvider;

  DrawerProvider();

  double appBarTotalHeight = 0.0;

  int notificationCount = 0;

  Future<void> init(BuildContext context) async {
    appBarTotalHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;

    userGenericProvider =
        Provider.of<UserGenericProvider>(getContext(), listen: false);

    notificationCount = userGenericProvider?.readNotificationCount ?? 0;

    Utils.logPrint("readNotificationCount drawer $notificationCount");

    notifyListeners();
  }

  void loadProfile() {
    navPush(AppRoutes.evaChatHistory);
  }

  void loadEvaChatHistory() {
    // ui_interaction
    navPush(AppRoutes.evaChatHistory);
  }

  void loadExtra() {
    navPush(AppRoutes.appExtraOption);
  }

  void loadfaq() {
    navPush(AppRoutes.faq);
  }

  void copyToken() {
    Clipboard.setData(ClipboardData(
        text: amplifyService.authToken ?? "authToken is empty try again"));

    Utils.logPrint(amplifyService.authToken);
  }

  Future<void> copyFcmToken() async {
    try {
      String? token = (Platform.isIOS)
          ? await TokenService.getFCMToken()
          : await FirebaseMessaging.instance.getToken();

      Clipboard.setData(
          ClipboardData(text: token ?? "FCM Token is empty try again"));
      Utils.logPrint('✅ Firebase FCM Token: $token');
    } catch (e) {
      Utils.logPrint('❌ Error getting FCM token: $e');
    }
  }
}
