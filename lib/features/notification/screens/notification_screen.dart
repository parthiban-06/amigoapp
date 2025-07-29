import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/notification/models/get_notifications.dart';
import 'package:visaamigo/features/notification/provider/notification_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationProvider notificationProvider;

  @override
  void initState() {
    super.initState();
    notificationProvider =
        getIt<NotificationProvider>(); // Retrieve NotificationProvider
    notificationProvider.init(); // Initialize the provider
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationProvider>(
      viewModel: notificationProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      onlyDesktop: true,
      buildAppBar: _buildAppBar(),
      onModelReady: (model) {
        model.init();
      },
      onPageBuilderMobileView:
          (BuildContext context, NotificationProvider viewModel) {
        return _buildMobileView(context, viewModel);
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return VisaAppBar(
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      onCancelPress: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildMobileView(
      BuildContext context, NotificationProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _buildNotificationContent(context, viewModel),
        VSpacings.medium
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 57.h,
        child: Align(
          alignment: Alignment.centerLeft,
          child: VisaTextView(
            text: S.of(context).notifications,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.semibold,
            fontSize: 24.sp,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationContent(
      BuildContext context, NotificationProvider viewModel) {
    if (_hasNotifications(viewModel)) {
      return _buildNotificationList(context, viewModel);
    } else {
      return _buildEmptyState(context, viewModel);
    }
  }

  bool _hasNotifications(NotificationProvider viewModel) {
    return viewModel.notificationResponse != null &&
        viewModel.notificationResponse!.data.isNotEmpty;
  }

  Widget _buildEmptyState(
      BuildContext context, NotificationProvider viewModel) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: VisaTextView(
            text: _getEmptyStateText(viewModel),
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: 18.sp,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
            lineHeight: 1.29,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _getEmptyStateText(NotificationProvider viewModel) {
    return (viewModel.notificationResponse == null)
        ? ""
        : S.of(context).no_notification;
  }

  Widget _buildNotificationList(
      BuildContext context, NotificationProvider viewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.notificationResponse!.data.length,
        itemBuilder: (context, index) {
          return _buildNotificationItem(context, viewModel, index);
        },
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, NotificationProvider viewModel, int index) {
    final notification = viewModel.notificationResponse!.data.elementAt(index);

    return InkWell(
      onTap: () => _handleNotificationTap(viewModel, notification, index),
      child: Column(
        children: [
          _buildNotificationItemContent(context, notification),
          _buildDivider(index, viewModel),
        ],
      ),
    );
  }

  void _handleNotificationTap(NotificationProvider viewModel,
      NotificationData notification, int index) {
    viewModel.moveToLink(
      notification.payload?.link,
      notification.id!,
      index,
    );
  }

  Widget _buildNotificationItemContent(
      BuildContext context, NotificationData notification) {
    return Focus(
      focusNode: FocusNode(),
      child: Semantics(
        value: _getNotificationSemanticsValue(context, notification),
        child: Container(
          color: _getNotificationBackgroundColor(notification),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification),
                _buildNotificationText(context, notification),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getNotificationSemanticsValue(
      BuildContext context, NotificationData notification) {
    return "${S.of(context).notification_status} ${notification.read == true ? S.of(context).read : S.of(context).unread}";
  }

  Color? _getNotificationBackgroundColor(NotificationData notification) {
    return notification.read ?? false
        ? null
        : VisaColors.blueBackgroundLightNew;
  }

  Widget _buildNotificationIcon(NotificationData notification) {
    final isRead = notification.read.toString() == "true";

    if (isRead) {
      return SvgPicture.asset(
        Assets.iconsIcUnreadNotificationBell,
        width: 24.w,
        height: 24.h,
      );
    } else {
      return SvgPicture.asset(
        Assets.iconsIcNotification,
        height: 24.w,
        width: 24.w,
      );
    }
  }

  Widget _buildNotificationText(
      BuildContext context, NotificationData notification) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotificationTitle(context, notification),
          VisaSizeBox(height: 4.h),
          _buildNotificationBody(context, notification),
        ],
      ),
    );
  }

  Widget _buildNotificationTitle(
      BuildContext context, NotificationData notification) {
    return SizedBox(
      width: (context.screenWidth - 85.w),
      child: VisaTextView(
        text: notification.title ?? "",
        semanticsLabel: S.of(context).title,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.semibold,
        fontSize: 16.sp,
        customColor: VisaColors.black,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: 0,
      ),
    );
  }

  Widget _buildNotificationBody(
      BuildContext context, NotificationData notification) {
    return SizedBox(
      width: (context.screenWidth - 85.w),
      child: VisaTextView(
        text: notification.body ?? "",
        softWrap: true,
        semanticsLabel: S.of(context).description,
        overflow: TextOverflow.fade,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.regular,
        fontSize: 14.sp,
        customColor: VisaColors.black,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: 0,
      ),
    );
  }

  Widget _buildDivider(int index, NotificationProvider viewModel) {
    if ((index + 1) < (viewModel.itemLength - 1)) {
      return const Divider(
        height: 1,
        color: VisaColors.greyBackGround,
      );
    }
    return const SizedBox();
  }
}
