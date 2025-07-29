import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/login/model/login_model.dart';
import 'package:visaamigo/features/login/view/login_view.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/proivder/theme_provider.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/ui/userdashboard/user_dashboard_provider.dart';
import 'package:visaamigo/utils/Inactive_session.dart';
import 'package:visaamigo/utils/responsive_util.dart';

import '../ai_chat_history_screen_test.dart';
import '../utils/utils_mocks.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([
  LoginViewModel,
  InactivityService,
  ResponsiveUtil,
  UserDashboardProvider,
  ThemeProvider,
  SelectLanguageGenericProvider,
  // AmplifyAuthCognito
])
void main() {
  Provider.debugCheckInvalidValueType = null;
  late MockLoginViewModel mockViewModel;
  late MockInactivityService mockInactivityService;
  late MockResponsiveUtil mockResponsiveUtil;
  late MockUserDashboardProvider mockUserDashboardProvider;
  late MockThemeProvider mockThemeProvider;
  late MockSelectLanguageGenericProvider mockSelectLanguageGenericProvider;
  // late MockAmplifyAuthCognito mockAuth;

  setUp(() async {
    await dotenv.load(fileName: "config/prod/.env");

    // mockAuth = MockAmplifyAuthCognito(); // ✅ Mock Amplify Auth

    mockViewModel = MockLoginViewModel();
    mockInactivityService = MockInactivityService();
    mockResponsiveUtil = MockResponsiveUtil();
    mockUserDashboardProvider = MockUserDashboardProvider();
    mockThemeProvider = MockThemeProvider();
    mockSelectLanguageGenericProvider = MockSelectLanguageGenericProvider();

    // Mocking LoginViewModel behavior
    when(mockViewModel.formKey).thenReturn(GlobalKey<FormState>());
    when(mockViewModel.email).thenReturn(TextEditingController());
    when(mockViewModel.pass).thenReturn(TextEditingController());
    when(mockViewModel.isLoginButtonDisable).thenReturn(false);
    when(mockViewModel.validStateChange())
        .thenReturn(null); // ✅ Ensure validStateChange() is stubbed
    when(mockViewModel.signInButton())
        .thenReturn(null); // ✅ Ensure signInButton() is stubbed

    when(mockSelectLanguageGenericProvider.isRTL).thenReturn(false);
    when(mockThemeProvider.isDarkMode).thenReturn(false);

    // ✅ Mocking ResponsiveUtil method 'isDesktop'
    when(mockResponsiveUtil.isDesktop(context: anyNamed("context")))
        .thenReturn(false);

    when(mockResponsiveUtil.isTablet(context: anyNamed("context")))
        .thenReturn(false);

    // ✅ Mocking responsiveWrapper in ResponsiveUtil
    when(mockResponsiveUtil.responsiveWrapper(
      context: anyNamed("context"),
      mobileView: anyNamed("mobileView"),
      tabletView: anyNamed("tabletView"),
      desktopView: anyNamed("desktopView"),
    )).thenAnswer((invocation) => invocation.namedArguments[#mobileView]);

    // ✅ Mocking locale in SelectLanguageGenericProvider
    when(mockSelectLanguageGenericProvider.locale)
        .thenReturn(const Locale('en'));

    // ✅ Mocking themeMode in ThemeProvider
    when(mockThemeProvider.themeMode).thenReturn(ThemeMode.light);

    // // ✅ Mock Amplify sign-in behavior to return success
    // when(mockAuth.signIn(
    //         username: "ayush.chauhan@trantorinc.com", password: "Ayush@123"))
    //     .thenAnswer((_) async => const CognitoSignInResult(
    //           isSignedIn: true,
    //           nextStep: AuthNextSignInStep(signInStep: AuthSignInStep.done),
    //         ));
    //
    // // ✅ Mock LoginViewModel's sign-in function to call Amplify
    // when(mockViewModel.signInButton()).thenAnswer((_) async {
    //   return await mockAuth.signIn(
    //       username: "ayush.chauhan@trantorinc.com", password: "Ayush@123");
    // });
  });

  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleWH: () => true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            Provider<InactivityService>.value(value: mockInactivityService),
            Provider<ResponsiveUtil>.value(value: mockResponsiveUtil),
            Provider<SelectLanguageGenericProvider>.value(
                value: mockSelectLanguageGenericProvider),
            Provider<UserDashboardProvider>.value(
                value: mockUserDashboardProvider),
            Provider<ThemeProvider>.value(value: mockThemeProvider),
            ChangeNotifierProvider<LoginViewModel>.value(value: mockViewModel),
            // Provider<AmplifyAuthCognito>.value(value: mockAuth),
            // ✅ Ensure LoginViewModel is in the widget tree
          ],
          child: Consumer2<ThemeProvider, SelectLanguageGenericProvider>(
              builder: (context, themeProvider, languageProvider, child) {
            return MaterialApp(
                locale: languageProvider.locale,
                supportedLocales: S.delegate.supportedLocales,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                title: "Visa-DHE",
                theme: VisaTheme.lightTheme,
                darkTheme: VisaTheme.lightTheme,
                themeMode: themeProvider.themeMode,
                home: LoginView(
                    UserModel(email: "ayush.chauhan@trantorinc.com")));
          }),
        );
      },
    );
  }

  testWidgets('Login screen UI test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify email field exists
    expect(find.byKey(const Key("emailField")), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key("emailField")), "ayush.chauhan@trantorinc.com");
    await tester.pump(); // ✅ Ensure UI rebuilds
    verifyNever(mockViewModel.validStateChange()).called(0);

    // Verify password field exists
    expect(find.byKey(const Key("passwordField")), findsOneWidget);
    await tester.enterText(find.byKey(const Key("passwordField")), "Ayush@123");
    await tester.pump(); // ✅ Ensure UI rebuilds
    verifyNever(mockViewModel.validStateChange()).called(0);

    // Verify login button exists and tap it
    // expect(find.byKey(const Key("loginButton")), findsOneWidget);
    // await tester.tap(find.byKey(const Key("loginButton")));
    // await tester.pump();

    // ✅ Verify sign-in is called on Amplify
    // verifyNever(mockAuth.signIn(
    //         username: "ayush.chauhan@trantorinc.com", password: "Ayush@123"))
    //     .called(0);
  });
}
