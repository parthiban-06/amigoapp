import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../select_languages/providers/language_selection_generic_provider.dart';

class ProfileSwitchTiles extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> valueChanged;

  const ProfileSwitchTiles(
      {super.key,
      required this.title,
      required this.value,
      required this.valueChanged});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          title + " " +(value == true ? S.of(context).is_on : S.of(context).is_off),
      container: true,
      button: true,
      onTap: () {
        valueChanged(!value);
        Utils.announceMessage(title + " " +
            (!value == true ? S.of(context).is_on : S.of(context).is_off));
      },
      child: ExcludeSemantics(
        excluding: true,
        child: SizedBox(
          height: AppSizes.heightFourtyFive,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: VisaTextView(
                  text: title,
                  softWrap: true,
                  semantics: false,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.customLarge,
                  fontFamily: VisaFontWeight.medium,
                  fontSize: AppSizes.fontMedium,
                  customColor: VisaColors.black,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: -0.5,
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: ExcludeSemantics(
                  excluding: true,
                  child: CupertinoSwitch(
                      value: value,
                      inactiveTrackColor: VisaColors.textFieldBorder,
                      inactiveThumbColor: VisaColors.white,
                      activeTrackColor: VisaColors.primary,
                      onChanged: (val) {
                        final localLanguageProvider =
                        Provider.of<SelectLanguageGenericProvider>(context,
                            listen: false);
        
                        FirebaseAnalyticsService.logEvent(
                            eventName: AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
                            parameters: {
                              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                              val ? "toggle_on" : "toggle_off",
                              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                              localLanguageProvider.getKeyFromValue(title)
                            });
                        valueChanged(val);
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
