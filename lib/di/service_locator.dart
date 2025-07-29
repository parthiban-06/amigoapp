import 'package:get_it/get_it.dart';
import 'package:visaamigo/di/ai_assistant_di.dart'
    show
        setupAiAssistantCommonStepsProvider,
        setupAiAssistantDependencies,
        setupAiAssistantGreetingProvider,
        setupAiAssistantMainProvider,
        setupAiAssistantPromptsScreenProvider,
        setupAiAssistantThreadsScreenProvider,
        setupAiAssistantWelcomeProvider,
        setupAiChatHistoryProvider,
        setupChatProvider,
        setupTutorialProvider;
import 'package:visaamigo/di/companion_di.dart' show setupCompanionDependencies;
import 'package:visaamigo/di/confirm_forgot_pass_code_di.dart'
    show setupConfirmForgotPassCodeDependencies;
import 'package:visaamigo/di/drawer_di.dart' show setupDrawerDependencies;
import 'package:visaamigo/di/enable_mfa_di.dart'
    show setupEnableMfaDependencies;
import 'package:visaamigo/di/home_di.dart' show setupHomeDependencies;
import 'package:visaamigo/di/login_di.dart'
    show setUpConfirmCodeProvider, setupLoginDependencies;
import 'package:visaamigo/di/navigation_di.dart' show setupNavigationProvider;
import 'package:visaamigo/di/notification_di.dart'
    show setupNotificationDependencies;
import 'package:visaamigo/di/profile_di.dart' show setupProfileDependencies;
import 'package:visaamigo/di/redirecting_di.dart'
    show setupRedirectingDependencies;
import 'package:visaamigo/di/register_email_di.dart'
    show setupRegisterEmailDependencies;
import 'package:visaamigo/di/responsive_util_di.dart'
    show setupResponsiveUtilDI;
import 'package:visaamigo/di/select_languages_di.dart'
    show setupSelectLanguagesDependencies;
import 'package:visaamigo/di/signup_di.dart' show setupSignUpDependencies;
import 'package:visaamigo/di/splash_screen_di.dart'
    show setupSplashScreenDependencies;
import 'package:visaamigo/di/term_condition_di.dart';
import 'package:visaamigo/di/ticket_di.dart' show setupTicketsModuleDI;
// import 'package:visaamigo/di/user_generic.dart'
//     show setupUserGenericProviderDependencies;
import 'package:visaamigo/di/wallet_di.dart' show setupWalletDependencies;

import 'core_di.dart';
import 'forgot_pass_di.dart';
import 'rate_us_di.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Setup Core Dependencies
  setupCoreDependencies(getIt);
  // Setup Module-Specific Dependencies
  setupForgotPassDependencies(getIt);
  setupRateUsDependencies(getIt);
  setupNotificationDependencies(getIt);
  setupConfirmForgotPassCodeDependencies(getIt);
  setupSplashScreenDependencies(getIt);
  setupWalletDependencies(getIt);
  setupSelectLanguagesDependencies(getIt);
  setupTicketsModuleDI(getIt);
  setupResponsiveUtilDI(getIt);
  setupSignUpDependencies(getIt);
  setupRegisterEmailDependencies(getIt);
  setupRedirectingDependencies(getIt);
  // setupUserGenericProviderDependencies(getIt);
  setupProfileDependencies(getIt);
  setupLoginDependencies(getIt);
  setupHomeDependencies(getIt);
  setupEnableMfaDependencies(getIt);
  setupDrawerDependencies(getIt);
  setupCompanionDependencies(getIt);
  setupAiAssistantDependencies(getIt);
  //setupAiAssistantMainProvider(getIt);
  setupAiChatHistoryProvider(getIt);
  setupChatProvider(getIt);
  setupAiAssistantWelcomeProvider(getIt);
  setupNavigationProvider(getIt);
  setupAiAssistantThreadsScreenProvider(getIt);
  setupAiAssistantPromptsScreenProvider(getIt);
  setupTutorialProvider(getIt);
  setupAiAssistantCommonStepsProvider(getIt);
  setupAiAssistantGreetingProvider(getIt);
  setUpConfirmCodeProvider(getIt);
  setupTermAndConditionDependencies(getIt);
}
