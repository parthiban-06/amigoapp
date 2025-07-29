import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/provider/faq_provider.dart';
import 'package:visaamigo/features/profile/widgets/faqs_category.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';
import '../../../custom_widgets/visa_appbar_actions.dart';
import '../../../custom_widgets/visa_button.dart';
import '../../../custom_widgets/visa_size_box.dart';
import '../../../generated/assets.dart';
import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/responsive_util.dart';
import '../widgets/faq_search_widget.dart';
import '../widgets/faq_support.dart';
import '../widgets/faqs_category_desktop.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({
    super.key,
  });

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late ResponsiveUtil responsive;
  late FaqProvider faqProvider;

  @override
  void initState() {
    super.initState();
    faqProvider = GetIt.I<FaqProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FaqProvider>(
      viewModel: faqProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      onlyDesktop: true,
      screenBackgroundImage: null,
      buildAppBar: _buildAppBar(context),
      onModelReady: (model) {
        model.init();
        Utils.announceMessage(S.of(context).faq_screen);
      },
      onPageBuilderMobileView: (BuildContext context, FaqProvider viewModel) {
        return _buildMobileView(context, viewModel);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return VisaAppBar(
      isActionButtonShow: true,
      isCancelWithTextButtonShow: _isCancelWithTextButtonShow(context),
      isLoginButtonShow: _isLoginButtonShow(context),
      onCancelPress: () {
        if (responsive.isMobileWeb(context: context)) {
          faqProvider.navigateToHomePage();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  bool _isCancelWithTextButtonShow(BuildContext context) {
    return (faqProvider.isUserLogin != null &&
            faqProvider.isUserLogin! &&
            responsive.isMobileWeb(context: context)) ||
        responsive.isMobile(context: context);
  }

  bool _isLoginButtonShow(BuildContext context) {
    return faqProvider.isUserLogin != null &&
        faqProvider.isUserLogin! == false &&
        responsive.isMobileWeb(context: context);
  }

  Widget _buildMobileView(BuildContext context, FaqProvider viewModel) {
    final isDesktop = viewModel.isDesktopView;
    final isMobileWeb = viewModel.isMobileWebView;
    return Stack(
      children: [
        _buildBackground(isDesktop),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(context, viewModel, isDesktop, isMobileWeb),
              FaqSearch(
                provider: viewModel,
                isMobileWeb: isMobileWeb,
                isDesktop: isDesktop,
              ),
              _buildFaqListSection(context, viewModel, isDesktop, isMobileWeb),
              _buildViewFullFaqsButton(
                  context, viewModel, isDesktop, isMobileWeb),
              VSpacings.xsmall,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(bool isDesktop) {
    if (isDesktop &&
        faqProvider.isUserLogin != null &&
        faqProvider.isUserLogin! == false) {
      return Positioned.fill(
        child: Image.asset(
          Assets.imagesGradientHeader,
          fit: BoxFit.fill,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeaderRow(BuildContext context, FaqProvider viewModel,
      bool isDesktop, bool isMobileWeb) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: VisaTextView(
              text: isDesktop || isMobileWeb
                  ? S.of(context).frequently_asked_questions
                  : S.of(context).faqs,
              softWrap: true,
              semanticsLabel: S.of(context).frequently_asked_questions,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.semibold,
              fontSize: 24.sp,
              maxLines: 3,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: -1,
            ),
          ),
          _buildHeaderAction(context, viewModel, isDesktop, isMobileWeb),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(BuildContext context, FaqProvider viewModel,
      bool isDesktop, bool isMobileWeb) {
    if (isDesktop &&
        faqProvider.isUserLogin != null &&
        faqProvider.isUserLogin! == false) {
      return VisaButton(
        text: S.of(context).login_to_view_the_complete_list,
        height: AppSizes.heightFiftyFive,
        fontSize: AppSizes.fontMedium,
        fontWeight: VisaFontWeight.medium,
        variant: VisaButtonVariant.white,
        buttonTextColor: VisaColors.primary,
        onPressed: () {
          viewModel.navigateToLoginPage();
        },
        contentPadding: EdgeInsets.only(left: 10.w, right: 10.w),
        lineHeight: 1.39,
      );
    } else if (isDesktop) {
      return VisaAppBarActions(
        onPressed: () {
          viewModel.navigateToHomePage();
        },
        visaTextStyle: VisaTextStyle.bodyMedium,
        visaTextTheme: VisaTextTheme.customTextColor,
        isIconShow: true,
        isTextShow: true,
        text: S.of(context).close.toUpperCase(),
        icons: Icons.close,
        iconColor: VisaColors.black,
        iconSize: AppSizes.sixteenRadius,
        letterSpacing: AppSizes.twoRadius,
        customColor: VisaColors.black,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFaqListSection(BuildContext context, FaqProvider viewModel,
      bool isDesktop, bool isMobileWeb) {
    if (viewModel.faqResponse == null) {
      return const SizedBox();
    }
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
        itemCount: viewModel.filteredFaqCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.filteredFaqCategories.length) {
            return _buildFaqSupportSection(viewModel, isDesktop, isMobileWeb);
          }
          return _buildFaqCategory(
              context, viewModel, index, isDesktop, isMobileWeb);
        },
      ),
    );
  }

  Widget _buildFaqCategory(BuildContext context, FaqProvider viewModel,
      int index, bool isDesktop, bool isMobileWeb) {
    if (faqProvider.isUserLogin != null &&
        faqProvider.isUserLogin! == true &&
        (isDesktop || isMobileWeb)) {
      return FaqsCategoryDesktop(
        faqCategory: viewModel.filteredFaqCategories[index],
        index: index,
        provider: viewModel,
      );
    } else {
      return FaqsCategory(
        faqCategory: viewModel.filteredFaqCategories[index],
      );
    }
  }

  Widget _buildFaqSupportSection(
      FaqProvider viewModel, bool isDesktop, bool isMobileWeb) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaSizeBox(
          height: isDesktop ? AppSizes.heightFourty : Sizes.tenInt.h,
        ),
        FaqSupport(
          faqViewModel: viewModel,
          isDesktop: isDesktop,
          isMobileWeb: isMobileWeb,
        ),
        VSpacings.xxlarge,
      ],
    );
  }

  Widget _buildViewFullFaqsButton(BuildContext context, FaqProvider viewModel,
      bool isDesktop, bool isMobileWeb) {
    if (viewModel.faqResponse == null || isDesktop || isMobileWeb) {
      return const SizedBox();
    }
    return VisaButton(
      text: S.of(context).view_full_faqs,
      semanticTitle: S.of(context).view_full +
          " " +
          S.of(context).frequently_asked_questions,
      onPressed: () {
        AppRouter.router.push(AppRoutes.redirecting, extra: {
          "url":
              "${dotenv.env["WEB_URL"]}${FirebaseAnalyticsService.cleanRoutePath(AppRoutes.faq)}",
          "deeplink": "",
          "openInternalBrowser": false,
          "bottomMessage": S.of(context).you_are_being_to_faqs,
        });
      },
      variant: VisaButtonVariant.primary,
      isDisable: false,
    );
  }
}
