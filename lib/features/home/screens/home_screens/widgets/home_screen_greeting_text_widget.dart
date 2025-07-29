import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/date_util.dart';
import '../../../providers/home_provider.dart';

class HomeScreenGreetingTextWidget extends StatelessWidget {
  final HomeViewProvider homeViewProvider;

  const HomeScreenGreetingTextWidget(
      {super.key, required this.homeViewProvider});

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserGenericProvider>();
    return Visibility(
      visible: homeViewProvider.userModel != null,
      maintainState: true,
      maintainSize: true,
      maintainAnimation: true,
      child: VisaTextView(
        text:
            "${DateUtil.getTimeOfDayGreetingWithPreFix(context, true)}, ${userProvider.userModel != null ? userProvider.userModel!.firstName : ""}.",
        style: VisaTextStyle.displayBodyXl,
        fontSize: AppSizes.fontMedium,
        letterSpacing: 0,
        lineHeight: 1.39,
        fontFamily: VisaFontWeight.semibold,
        colorTheme: VisaTextTheme.customTextColor,
        customColor: VisaColors.black,
      ),
    );
  }
}
