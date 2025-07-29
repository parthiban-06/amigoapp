import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_auto_complete_search_view.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_lottie_animation_widget.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_assistant_main_provider.dart';
import 'ai_assistant_teams_slider_widget.dart';

class AiAssistantTeamsWidget extends StatelessWidget {
  const AiAssistantTeamsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final appBarTotalHeight = MediaQuery.paddingOf(context).top;
    final aiAssistantProvider =
        Provider.of<AiAssistantMainProvider>(context, listen: true);
    final isDesktop = _isDesktopView(context);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: _getMainAxisAlignment(isKeyboardVisible),
          children: [
            _buildTopSpacing(isKeyboardVisible),
            _buildFiFaImageContent(
                aiAssistantProvider, isKeyboardVisible, isDesktop),
            _buildTeamsContent(context, aiAssistantProvider, s,
                appBarTotalHeight, isKeyboardVisible, isDesktop),
          ],
        );
      },
    );
  }

  bool _isDesktopView(BuildContext context) {
    return context.screenWidth >= 1200 ||
        (context.screenWidth >= 600 && context.screenWidth < 1200);
  }

  MainAxisAlignment _getMainAxisAlignment(bool isKeyboardVisible) {
    return isKeyboardVisible ? MainAxisAlignment.start : MainAxisAlignment.end;
  }

  Widget _buildTopSpacing(bool isKeyboardVisible) {
    return !isKeyboardVisible
        ? SizedBox(height: Sizes.fortyInt.h)
        : const SizedBox();
  }

  Widget _buildTeamsContent(
    BuildContext context,
    AiAssistantMainProvider aiAssistantProvider,
    S s,
    double appBarTotalHeight,
    bool isKeyboardVisible,
    bool isDesktop,
  ) {
    if (aiAssistantProvider.teamsList == null ||
        aiAssistantProvider.teamsList!.isEmpty) {
      return Container(height: Sizes.oneHundredTwenty.h);
    }

    return Column(
      mainAxisSize: isKeyboardVisible ? MainAxisSize.max : MainAxisSize.min,
      children: [
        _buildKeyboardSpacing(isKeyboardVisible, appBarTotalHeight),
        _buildSearchView(context, aiAssistantProvider, s, isDesktop),
        AppSizes.mediumVS,
        _buildTeamsSlider(aiAssistantProvider),
        _buildBottomButtons(context, s, isDesktop, aiAssistantProvider),
        _buildBottomSpacing(isKeyboardVisible),
      ],
    );
  }

  Widget _buildKeyboardSpacing(
      bool isKeyboardVisible, double appBarTotalHeight) {
    return isKeyboardVisible
        ? SizedBox(height: appBarTotalHeight + 32.h)
        : const SizedBox();
  }

  Widget _buildSearchView(BuildContext context,
      AiAssistantMainProvider aiAssistantProvider, S s, bool isDesktop) {
    return SizedBox(
      height: AppSizes.heightThrityFive,
      width: isDesktop ? AppSizes.fourFiveFourWidth : context.screenWidth,
      child: VisaAutoCompleteSearchView(
        items: aiAssistantProvider.teamsList!,
        itemLabelExtractor: (team) => team.name ?? "",
        searchIcon: SvgPicture.asset(
          Assets.iconsIcSearch,
          width: AppSizes.dimSmall,
          height: AppSizes.heightSmall,
        ),
        suffixIcon: Icon(
          Icons.clear,
          size: Sizes.sixteen.w,
          color: VisaColors.black,
        ),
        searchColor: VisaColors.black,
        isUpperCase: true,
        padding: EdgeInsets.symmetric(horizontal: Sizes.sixteen),
        height: Sizes.sixty,
        width: context.screenWidth,
        filled: false,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        hintText: s.type_here_new.toUpperCase(),
        onSelected: (value) {
          Utils.hideKeyboard(context);
          aiAssistantProvider.getSelectedIndex(value.name!);
        },
        onChanged: (value) {
          aiAssistantProvider.getSelectedIndex(value);
        },
        onTap: () {},
      ),
    );
  }

  Widget _buildTeamsSlider(AiAssistantMainProvider aiAssistantProvider) {
    return AiAssistantTeamsSliderWidget(
      provider: aiAssistantProvider,
    );
  }

  Widget _buildBottomButtons(BuildContext context, S s, bool isDesktop,
      AiAssistantMainProvider aiAssistantProvider) {
    final isLargeText = MediaQuery.of(context).textScaler.scale(1) > 1.25;

    if (!isLargeText) {
      return const SizedBox();
    }

    if (isDesktop && aiAssistantProvider.currentPage + 1 == 2) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: isDesktop ? 400.w : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.sixteenRadius,
              vertical: AppSizes.twentyEightRadius,
            ),
            child:
                _buildButtonLayout(context, s, isDesktop, aiAssistantProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonLayout(BuildContext context, S s, bool isDesktop,
      AiAssistantMainProvider aiAssistantProvider) {
    final isLargeText = MediaQuery.of(context).textScaler.scale(1) > 1.25;

    if (isLargeText) {
      return _buildVerticalButtonLayout(
          context, s, isDesktop, aiAssistantProvider);
    } else {
      return _buildHorizontalButtonLayout(
          context, s, isDesktop, aiAssistantProvider);
    }
  }

  Widget _buildVerticalButtonLayout(BuildContext context, S s, bool isDesktop,
      AiAssistantMainProvider aiAssistantProvider) {
    return Column(
      children: [
        _buildContinueButton(context, s, aiAssistantProvider),
        SizedBox(height: 22.w),
        _buildSkipButton(s, isDesktop, aiAssistantProvider),
      ],
    );
  }

  Widget _buildHorizontalButtonLayout(BuildContext context, S s, bool isDesktop,
      AiAssistantMainProvider aiAssistantProvider) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildSkipButton(s, isDesktop, aiAssistantProvider),
        ),
        SizedBox(width: 22.w),
        Expanded(
          flex: 2,
          child: _buildContinueButton(context, s, aiAssistantProvider),
        ),
      ],
    );
  }

  Widget _buildContinueButton(
      BuildContext context, S s, AiAssistantMainProvider aiAssistantProvider) {
    return VisaButton(
      text: s.txt_continue,
      height: AppSizes.fiftySevenInt.toDouble(),
      width: context.screenWidth,
      variant: VisaButtonVariant.white,
      fontWeight: VisaFontWeight.medium,
      letterSpacing: AppSizes.zero,
      onPressed: () => _handleContinueAction(aiAssistantProvider),
    );
  }

  Widget _buildSkipButton(
      S s, bool isDesktop, AiAssistantMainProvider aiAssistantProvider) {
    return VisaButton(
      text: s.skip,
      height: AppSizes.fiftyThreeInt.toDouble(),
      width: AppSizes.oneThirtyTwo.toDouble(),
      variant: isDesktop ? VisaButtonVariant.primary : VisaButtonVariant.white,
      fontWeight: VisaFontWeight.medium,
      letterSpacing: AppSizes.zero,
      isOutlined: !isDesktop,
      onPressed: () => _handleSkipAction(aiAssistantProvider),
    );
  }

  Future<void> _handleContinueAction(
      AiAssistantMainProvider aiAssistantProvider) async {
    aiAssistantProvider.updateTeamPreference();
    aiAssistantProvider.navigateToAiAssistantThanksScreen();
  }

  Future<void> _handleSkipAction(
      AiAssistantMainProvider aiAssistantProvider) async {
    aiAssistantProvider.navigateToAiAssistantThanksScreen();
  }

  Widget _buildBottomSpacing(bool isKeyboardVisible) {
    return isKeyboardVisible
        ? const SizedBox.shrink()
        : Flexible(
            child: VisaSizeBox(
              height: Sizes.oneHundredSeventeen.h,
            ),
          );
  }

  Widget _buildFiFaImageContent(AiAssistantMainProvider aiAssistantProvider,
      bool isKeyboardVisible, bool isDesktop) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0, -1), // Starts at current position
                    end: const Offset(0, 0))
                .animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut, // Ensures smooth movement
              ),
            ),
            child: child,
          );
        },
        child: !isKeyboardVisible
            ? Column(
                key: ValueKey<bool>(!isKeyboardVisible),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VisaLottieAnimationWidget(
                    repeat: false,
                    assetPath: Assets.jsonTrophy,
                    //width: Sizes.twoHundred.w,
                    height: isDesktop
                        ? Sizes.twoHundred.h
                        : Sizes.twoHundredFifty.h,
                    isSetLastFrame: true,
                  ),
                  AppSizes.xlargeVS,
                ],
              )
            : const SizedBox.shrink());
  }
}
