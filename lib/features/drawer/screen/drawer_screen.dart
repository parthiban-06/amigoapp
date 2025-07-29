import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../core/base/view/base_view.dart';
import '../../../custom_widgets/visa_appbar.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/responsive_util.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import '../provider/drawer_provider.dart';
import '../widgets/drawer_widget.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  late DrawerProvider drawerProvider;
  late ResponsiveUtil responsive;

  @override
  void initState() {
    super.initState();
    // Retrieve DrawerProvider using GetIt
    drawerProvider = GetIt.I<DrawerProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //drawerProvider.init(context);
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DrawerProvider>(
      onlyDesktop: true,
      screenBackgroundColor: VisaColors.white,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      resizeToAvoidBottomInset: true,
      systemNavigationBarColor: context.theme.primaryColor,
      viewModel: drawerProvider,
      onModelReady: (model) {
        model.init(context);
      },
      screenBackgroundImage: null,
      buildAppBar: VisaAppBar(
        isHamburgerIconShow: responsive.kISWeb() &&
            (responsive.isMobile(context: context) ||
                responsive.isTablet(context: context)),
        isActionButtonShow: true,
        isRightSideHamburgerIconShow: false,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          drawerProvider.navPop();
        },
      ),
      onPageBuilderMobileView:
          (BuildContext context, DrawerProvider viewModel) {
        return Padding(
          padding: EdgeInsets.only(
            top: viewModel.appBarTotalHeight,
          ),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            padding: EdgeInsets.zero,
            children: [
              AppSizes.mediumVS,
              DrawerItemWidget(
                title: S.of(context).profile,
                onItemClick: () {
                  viewModel.navPush(AppRoutes.profilePage);
                },
                notificationCount: 0,
              ),
              DrawerItemWidget(
                title: S.of(context).notifications,
                onItemClick: () {
                  viewModel.navPush(AppRoutes.notification);
                },
                notificationCount:
                    Provider.of<UserGenericProvider>(context, listen: true)
                        .readNotificationCount,
              ),
              DrawerItemWidget(
                title: S.of(context).eva_history,
                onItemClick: () {
                  drawerProvider.loadEvaChatHistory();
                },
                notificationCount: 0,
              ),
              DrawerItemWidget(
                title: S.of(context).faq,
                semanticTitle: S.of(context).frequently_asked_questions,
                onItemClick: () {
                  drawerProvider.loadfaq();
                },
                notificationCount: 0,
              ),
              if (kDebugMode)
                DrawerItemWidget(
                  title: "Copy token",
                  onItemClick: () {
                    drawerProvider.copyToken();
                  },
                  notificationCount: 0,
                ),
              if (kDebugMode)
                DrawerItemWidget(
                  title: "Copy FCM Token",
                  onItemClick: () {
                    drawerProvider.copyFcmToken();
                  },
                  notificationCount: 0,
                ),
            ],
          ),
        );
      },
    );
  }
}
