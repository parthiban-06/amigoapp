import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../../custom_widgets/visa_button.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/app_routes_const.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../ai_assistant/providers/ai_assistant_main_provider.dart';
import '../../providers/home_provider.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  late HomeViewProvider homeViewProvider;
  late S s; // Localized strings

  @override
  void initState() {
    super.initState();
    homeViewProvider = GetIt.I<HomeViewProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewProvider>(
      viewModel: homeViewProvider,
      onlyDesktop: true,
      onModelReady: (model) {
        model.init(context);
      },
      onPageBuilderMobileView:
          (BuildContext context, HomeViewProvider viewModel) {
        return SingleChildScrollView(
          child: Column(
            children: [
              AppSizes.xlargeVS,
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: VisaButton(
                    text: "Copy Token",
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      viewModel.copyToken();
                    },
                    height: 50,
                    variant: VisaButtonVariant.primary,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VisaButton(
                  text: "Continue here",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    Preferences.removeKey(Preferences.isGettingToKnowDone);
                    Provider.of<NavigationProvider>(context, listen: false)
                        .goBranch(AppRoutes.homeScreenIndex);
                    Provider.of<AiAssistantMainProvider>(context, listen: false)
                        .resetAll();
                    viewModel.loadGreetingScreen();
                  },
                  height: 50,
                  variant: VisaButtonVariant.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VisaButton(
                  text: "Enable MFA",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    viewModel.setMFA(true);
                  },
                  height: 50,
                  variant: VisaButtonVariant.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VisaButton(
                  text: "Disable MFA",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    viewModel.setMFA(false);
                  },
                  height: 50,
                  variant: VisaButtonVariant.primary,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: VisaButton(
              //     text: "Clear Preference",
              //     icon: Icons.arrow_forward,
              //     onPressed: () {
              //       viewModel.clearPrefrence();
              //     },
              //     height: 50,
              //     variant: VisaButtonVariant.primary,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: VisaButton(
              //     text: "Language",
              //     icon: Icons.arrow_forward,
              //     onPressed: () {
              //       viewModel.changeLanguage();
              //     },
              //     height: 50,
              //     variant: VisaButtonVariant.primary,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VisaButton(
                  text: "Enable Biometric",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    viewModel.enableBiometrics();
                  },
                  height: 50,
                  variant: VisaButtonVariant.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VisaButton(
                  text: "Disable Biometric",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    viewModel.removeBioMetrics();
                  },
                  height: 50,
                  variant: VisaButtonVariant.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: VisaButton(
                  text: "Logout",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    viewModel.signOutButtonPressed();
                  },
                  height: 50,
                  variant: VisaButtonVariant.primary,
                ),
              ),
              AppSizes.mediumVS,
            ],
          ),
        );
      },
    );
  }
}
