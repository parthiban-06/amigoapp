import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/notification/models/get_notifications.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../ui/base/base_provider.dart';
import '../../profile/provider/user_generic_detail_provider.dart';

class NotificationProvider extends BaseProvider {
  int itemLength = 4;
  final UserDetailRepo userDetailRepo;
  NotificationResponse? notificationResponse;
  List<String> unreadMessage = [];

  NotificationProvider({required this.userDetailRepo});

  Future<void> init() async {
    isLoading = true;
    final rep = await userDetailRepo.getNotifications(
      NotificationResponse.fromJson,
    );

    if (rep.isSuccess) {
      notificationResponse = rep.data;
      setState();
      if (notificationResponse != null &&
          notificationResponse!.data.isNotEmpty) {
        int unreadCount = notificationResponse!.data
            .where((item) => item.read == false)
            .length;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.announceMessage(unreadCount.toStringAsFixed(0) +
              S.of(getContext()).unread_notifications);
        });
      }
      /*   Future.delayed(Duration(milliseconds: 350), () {
        for (int i = 0; i < notificationResponse!.data.length; i++) {
          if (notificationResponse!.data.elementAt(i).read.toString() ==
              "false") {
            userDetailRepo?.updateNotifications((json) => (), {"read": "true"},
                notificationResponse!.data.elementAt(i).id);
          }
        }
      });*/
    }
    isLoading = false;
  }

  moveToLink(String? link, String? msgId, int index) async {
    isLoading = true;

    if (notificationResponse != null &&
        notificationResponse!.data[index].read != true) {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      if (context.mounted) {
        // Assign the updated object back
        Provider.of<UserGenericProvider>(context, listen: false)
            .markNotificationRead();
      }

      await userDetailRepo.updateNotifications(
          (json) => (), {"read": "true"}, msgId ?? "");

      notificationResponse!.data[index] =
          notificationResponse!.data[index].copyWith(read: true);
    }

    isLoading = false;
    final navProvider =
        Provider.of<NavigationProvider>(getContext(), listen: false);

    switch (link) {
      case "/itinerary":
        navProvider.goBranch(AppRoutes.itineraryScreenIndex);
        break;

      case "/ticket":
        navProvider.goBranch(AppRoutes.ticketScreenIndex);
        break;

      case "/profile":
        navPush(AppRoutes.profilePage);
        break;

      case "/walet":
      case "/wallet":
        await navProvider.goBranch(AppRoutes.homeScreenIndex);
        navGo(AppRoutes.homeNestedWallet);
        break;

      default:
        Utils.logPrint("Page not found: $link");
        break;
    }
  }
}
