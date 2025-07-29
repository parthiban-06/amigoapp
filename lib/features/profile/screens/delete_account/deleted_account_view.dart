import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../custom_widgets/visa_textview.dart';
import '../../../../router/app_router.dart';
import '../../../../router/app_routes_const.dart';
import '../../../../utils/const_screen_size.dart';
import '../../../../utils/responsive_util.dart';
import '../../provider/delete_account_provider.dart';

class DeletedAccountView extends StatefulWidget {
  const DeletedAccountView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeletedAccountViewState createState() => _DeletedAccountViewState();
}

class _DeletedAccountViewState extends State<DeletedAccountView> {
  late DeleteAccountProvider deleteAccountProvider;
  late S s;

  @override
  void initState() {
    super.initState();
    deleteAccountProvider = GetIt.I<DeleteAccountProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
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
          AppRouter.router.go(AppRoutes.registeredEmail);
        },
      ),
      onModelReady: (model) {},
      onPageBuilderMobileView: (context, viewModel) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.dimSmall,
            vertical: AppSizes.heightSmall,
          ),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: Provider.of<ResponsiveUtil>(context)
                      .isDesktop(context: context)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VisaSvgIcon(
                        assetPath: Assets.iconsIcDelete,
                        color: VisaColors.primary,
                        height: Sizes.fiftyFiveInt.h,
                        width: Sizes.fiftyFiveInt.w,
                        useWithoutColor: true,
                      ),
                      VisaSizeBox(
                        height: Sizes.twentyInt.toDouble(),
                      ),
                      VisaTextView(
                        text: s.your_account_has_been_deleted,
                        colorTheme: VisaTextTheme.customTextColor,
                        customColor: VisaColors.primary,
                        fontSize: AppSizes.fontSmall,
                        fontFamily: VisaFontWeight.bold,
                        overflow: TextOverflow.visible,
                        lineHeight: (36 / 34).toDouble(),
                        textAlign: TextAlign.center,
                        letterSpacing: -2,
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    VisaButton(
                      text: s.done,
                      onPressed: viewModel.navigateToRegisteredEmailScreen,
                      isDisable: false,
                      fontWeight: VisaFontWeight.medium,
                      variant: VisaButtonVariant.primary,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
