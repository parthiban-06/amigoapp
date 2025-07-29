import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/features/profile/provider/delete_account_provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/theme/theme.dart';
import '../../../../custom_widgets/custom_visa_two_button.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../custom_widgets/visa_textview.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import 'widgets/delete_account_text_span_widget.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeleteAccountViewState createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  late DeleteAccountProvider deleteAccountProvider;
  late S s;
  late final double fontFourteen;

  @override
  void initState() {
    super.initState();
    deleteAccountProvider = GetIt.I<DeleteAccountProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    fontFourteen = AppSizes.fontfourteen;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DeleteAccountProvider>(
      viewModel: deleteAccountProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onModelReady: (model) {
        model.init();
      },
      onPageBuilderMobileView: (context, viewModel) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.dimSmall,
            vertical: AppSizes.heightSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VisaTextView(
                        text: s.delete_account,
                        softWrap: true,
                        semanticsFocus: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.semibold,
                        fontSize: AppSizes.fontXSmall,
                        maxLines: 1,
                        customColor: VisaColors.black,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: -1,
                        lineHeight: 1.04,
                      ),
                      VisaSizeBox(
                        height: Sizes.twentyNineInt.toDouble(),
                      ),
                      DeleteAccountTextSpanWidget(
                        isCompanion: viewModel.isCompanion,
                      ),
                      VisaSizeBox(
                        height: Sizes.fiftyOneInt.toDouble(),
                      ),
                      !Utils.getFontSize(context) || viewModel.isCompanion
                          ? const SizedBox()
                          : VisaTextView(
                              text: s.come_back_message,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: VisaTextStyle.customLarge,
                              fontFamily: VisaFontWeight.regular,
                              fontSize: fontFourteen,
                              customColor: VisaColors.black,
                              colorTheme: VisaTextTheme.customTextColor,
                              lineHeight: 1.29,
                            ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Utils.getFontSize(context) || viewModel.isCompanion
                      ? const SizedBox()
                      : VisaTextView(
                          text: s.come_back_message,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.regular,
                          fontSize: fontFourteen,
                          customColor: VisaColors.black,
                          colorTheme: VisaTextTheme.customTextColor,
                          lineHeight: 1.29,
                        ),
                  VisaSizeBox(
                    height: Sizes.thirtyInt.toDouble(),
                  ),
                  CustomTwoButtons(
                    leftButtonText: S.of(context).cancel,
                    rightButtonText: S.of(context).txt_continue,
                    rightButtonDisable: false,
                    onLeftButtonPressed: () {
                      viewModel.closeScreen();
                    },
                    onRightButtonPressed: () {
                      viewModel.navigateToConfirmDeleteAccountScreen();
                    },
                    isRightButtonLoading: false,
                    isLeftButtonLoading: false,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
