import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/companion/providers/list_companion_provider.dart';
import 'package:visaamigo/features/companion/widgets/companion_card.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../custom_widgets/visa_appbar.dart';
import '../../../utils/utils.dart';

class ListCompanionScreen extends StatefulWidget {
  const ListCompanionScreen({super.key});

  @override
  State<ListCompanionScreen> createState() => _ListCompanionScreenState();
}

class _ListCompanionScreenState extends State<ListCompanionScreen> {
  late ListCompanionProvider listCompanionProvider;
  late double heightTen;
  late double horizontalPadding;

  @override
  void initState() {
    super.initState();
    // Retrieve ListCompanionProvider using GetIt
    listCompanionProvider = GetIt.I<ListCompanionProvider>();
    listCompanionProvider.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listCompanionProvider.setContext(context);
    heightTen = AppSizes.ten;
    horizontalPadding = AppSizes.dimSmall;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ListCompanionProvider>(
      viewModel: listCompanionProvider,
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
        Utils.announceMessage(S.of(context).companion_details_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, ListCompanionProvider viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VisaSizeBox(
                        height: heightTen,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: heightTen),
                        child: VisaTextView(
                          text: S.of(context).companion_details,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: AppSizes.fontXSmall,
                          maxLines: 1,
                          customColor: VisaColors.black,
                          colorTheme: VisaTextTheme.customTextColor,
                          letterSpacing: -1,
                        ),
                      ),
                      viewModel.companionList == null ||
                              viewModel.companionList!.data == null
                          ? const SizedBox()
                          : Column(
                              children: List.generate(
                                  viewModel.companionList!.data!.length,
                                  (index) {
                                return CompanionCardView(
                                  index: index + 1,
                                  onChange: () {
                                    viewModel.init();
                                  },
                                  onChangeResend: () {
                                    viewModel.resendInvite(viewModel
                                        .companionList!.data!
                                        .elementAt(index)
                                        .id);
                                  },
                                  matchResponse: viewModel.userMatches,
                                  companionProfile: viewModel
                                      .companionList!.data!
                                      .elementAt(index),
                                );
                              }),
                            )
                    ],
                  ),
                ),
              ),
            ),
            viewModel.showAddCompanion
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: AppSizes.heightSmall),
                    child: Column(
                      children: [
                        VisaButton(
                          text: S.of(context).add_companion2,
                          onPressed: () {
                            viewModel.addCompanionButton();
                          },
                          isDisable: false,
                          fontWeight: VisaFontWeight.medium,
                          variant: VisaButtonVariant.primary,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
