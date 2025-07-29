import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../provider/faq_provider.dart';

class FaqSearch extends StatelessWidget {
  final FaqProvider provider;
  final bool isDesktop;
  final bool isMobileWeb;

  const FaqSearch({
    super.key,
    required this.provider,
    required this.isDesktop,
    required this.isMobileWeb,
  });

  @override
  Widget build(BuildContext context) {
    return isDesktop || isMobileWeb
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisaTextField(
                controller: provider.searchController,
                hint: S.of(context).type_to_search,
                underlineInputBorder: false,
                isDense: false,
                errorText: "",
                contentPadding: EdgeInsets.all(16.r),
                fontSize: 12,
                letterSpacing: 2,
                vPadding: 0,
                isUpperCase: true,
                fontWeight: FontWeight.w500,
                textCapitalization: TextCapitalization.words,
                focusNode: provider.focusNode,
                borderTransparent: true,
                suffixIcon: provider.isSearchNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: 14.w),
                        child: InkWell(
                          onTap: () => provider.clearSearch(),
                          child: SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: Center(
                              child: SvgPicture.asset(
                                Assets.iconsIcClose,
                                height: 12.75.h,
                                width: 12.75.w,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
                prefixIcon: SizedBox(
                  width: 30.w,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          SvgPicture.asset(Assets.iconsIcSearch, width: 16.w),
                    ),
                  ),
                ),
                maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
                textInputType: TextInputType.text,
                onChanged: (val) {
                  provider.onSearchChanged(val);
                },
                onSubmitted: (val) {
                  // If needed
                },
                isValid: true,
              ),
              Container(
                width: isMobileWeb
                    ? context.screenWidth
                    : provider.isSearchNotEmpty
                        ? context.screenWidth
                        : 400.w,
                height: 1,
                alignment: Alignment.centerLeft,
                color: VisaColors.black,
              ),
              SizedBox(
                height: isDesktop ? 44.h : 16.h,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
