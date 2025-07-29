import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../../core/theme/theme.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../providers/ai_assistant_main_provider.dart';
import '../../providers/ai_prompt_personal_preferences_provider.dart';
import 'widgets/ai_prompts_list_widget.dart';

class AiPromptPersonalPreferencesScreen extends StatefulWidget {
  const AiPromptPersonalPreferencesScreen({super.key});

  @override
  State<AiPromptPersonalPreferencesScreen> createState() =>
      _AiPromptPersonalPreferencesScreenState();
}

class _AiPromptPersonalPreferencesScreenState
    extends State<AiPromptPersonalPreferencesScreen> {
  late AiPromptPersonalPreferencesProvider aiPromptPersonalPreferencesProvider;
  late AiAssistantMainProvider aiAssistantMainProvider;
  late S s;

  @override
  void initState() {
    super.initState();
    // Retrieve providers using GetIt
    aiPromptPersonalPreferencesProvider =
        GetIt.I<AiPromptPersonalPreferencesProvider>();
    aiAssistantMainProvider =
        Provider.of<AiAssistantMainProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    aiPromptPersonalPreferencesProvider.init(context);

    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: VisaColors.white, // Background color for the full area
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 200.h,
              width: double.infinity,
              child: Image.asset(
                Assets.imagesGradientHeaderNew,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        BaseView<AiPromptPersonalPreferencesProvider>(
          onlyDesktop: true,
          extendBodyBehindAppBar: true,
          addDefaultPadding: false,
          systemNavigationBarColor: Colors.white,
          setBottomSafeArea: true,
          wrapWithSafeArea: false,
          screenBackgroundColor: VisaColors.transparent,
          screenBackgroundImage: null,
          viewModel: aiPromptPersonalPreferencesProvider,
          buildAppBar: VisaAppBar(
            isActionButtonShow: true,
            isCancelWithTextButtonShow: true,
            cancelIconColor: VisaColors.white,
            cancelTextColor: VisaColors.white,
            onCancelPress: () {
              aiAssistantMainProvider.closeScreen();
            },
          ),
          onPageBuilderMobileView: (BuildContext context,
              AiPromptPersonalPreferencesProvider viewModel) {
            return SizedBox(
              height: context.screenHeight,
              width: context.screenWidth,
              child: viewModel.listQuestions != null &&
                      viewModel.listQuestions!.isNotEmpty
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: AppSizes.dimSmall,
                                right: AppSizes.dimSmall,
                                top: AppSizes.heightSmall,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  VisaAnimatedText(
                                    child: VisaTextView(
                                      text: s.personal_preferences,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: VisaTextStyle.displayTitleMedium,
                                      fontFamily: VisaFontWeight.semibold,
                                      customColor: VisaColors.black,
                                      colorTheme: VisaTextTheme.customTextColor,
                                      letterSpacing: -1,
                                      lineHeight: (25 / 24).toDouble(),
                                    ),
                                  ),
                                  VisaSizeBox(
                                    height: AppSizes.heightXSmall,
                                  ),
                                  VisaAnimatedText(
                                    child: VisaTextView(
                                      text: s.keep_customizing_your_trip,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: VisaTextStyle.displayBodyS,
                                      fontFamily: VisaFontWeight.regular,
                                      customColor: VisaColors.black,
                                      colorTheme: VisaTextTheme.customTextColor,
                                      lineHeight: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VisaSizeBox(
                              height: AppSizes.thirtyTwoHeight,
                            ),
                            AiPromptsListWidget(
                              viewModel: viewModel,
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                            valueListenable: viewModel.isAtBottom,
                            builder: (context, value, child) {
                              return Visibility(
                                visible: !value,
                                child: IgnorePointer(
                                  child: Container(
                                    height: context.screenHeight * 0.3.h,
                                    width: context.screenWidth,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          VisaColors.white.withAlpha(0),
                                          VisaColors.white,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0.4, 1],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    )
                  : const SizedBox.shrink(),
            );
          },
        )
      ],
    );
  }
}
