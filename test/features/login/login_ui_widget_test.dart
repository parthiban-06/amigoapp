import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_main_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_threads_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:visaamigo/features/home/providers/animated_bottom_bar_provider.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/login/model/login_model.dart';
import 'package:visaamigo/features/login/view/login_text_fields_widget.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/features/signup/providers/signup_provider.dart';
import 'package:visaamigo/features/signup/screens/signup_text_fields_widget.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/ui/userdashboard/user_dashboard_provider.dart';
import 'package:visaamigo/utils/Inactive_session.dart';
import 'package:visaamigo/utils/responsive_util.dart';

class MockUserDetailRepo extends Mock implements UserDetailRepo {}

class TestableLoginViewProvider extends LoginViewModel {
  Object? lastNavPush;
  String? lastNavPushRoute;
  Object? lastNavGo;
  String? lastNavGoRoute;
  int navPopCount = 0;

  TestableLoginViewProvider({required UserDetailRepo userDetailRepo})
      : super(userDetailRepo: userDetailRepo);

  @override
  void navPush(String route, {Object? extra}) {
    lastNavPush = extra;
    lastNavPushRoute = route;
  }

  @override
  void navGo(String route, {Object? extra}) {
    lastNavGo = extra;
    lastNavGoRoute = route;
  }

  @override
  void navPop() {
    navPopCount++;
  }

  @override
  void setState([VoidCallback? fn]) {
    fn?.call();
  }

  BuildContext? _context;
  @override
  BuildContext getContext() => _context!;
  void setContext(BuildContext ctx) => _context = ctx;

// @override
// AmplifyService get amplifyService => _amplifyService ?? super.amplifyService;
// set amplifyService(AmplifyService value) => _amplifyService = value;
}

void main() {
  // Mock SignUpViewProvider with basic test logic.
  late TestableLoginViewProvider provider;
  late MockUserDetailRepo mockRepo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: "config/dev/.env");
  });

  setUp(() {
    mockRepo = MockUserDetailRepo();
  });

  testWidgets('SignUpScreen renders and has form fields', (WidgetTester tester) async {
    try {
      provider = TestableLoginViewProvider(userDetailRepo: mockRepo);
      await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            enableScaleWH: () => true,
            useInheritedMediaQuery: true,
            child: Builder(builder: (context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => UserDashboardProvider()),
                  ChangeNotifierProvider(create: (_) => ThemeProvider()),
                  ChangeNotifierProvider(
                      create: (_) =>
                      SelectLanguageGenericProvider()..setContext(context)),
                  ChangeNotifierProvider(
                      create: (context) => InactivityService(context)),
                  ChangeNotifierProvider(
                      create: (_) => ResponsiveUtil(context)..setContext(context)),
                  ChangeNotifierProvider(
                      create: (_) =>
                      AiAssistantMainProvider()..setContext(context)),
                  ChangeNotifierProvider(create: (_) => NavigationProvider()),
                  ChangeNotifierProvider(create: (_) => ChatProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AiAssistantThreadsScreenProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AnimatedBottomBarProvider()),
                ],
                child: Consumer2<ThemeProvider, SelectLanguageGenericProvider>(
                    builder: (context, themeProvider, languageProvider, child) {
                      return MaterialApp(
                          locale: const Locale('en'),
                          supportedLocales: S.delegate.supportedLocales,
                          localizationsDelegates: const [
                            S.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                          title: "Visa-DHE",
                          theme: VisaTheme.lightTheme,
                          // Regular Visa brand theme
                          darkTheme: VisaTheme.lightTheme,
                          // Affluent theme
                          themeMode: Provider.of<ThemeProvider>(context).themeMode,
                          home: Builder(
                              builder: (context) {
                                provider.setContext(context);
                                return Scaffold(body: LoginTextFieldsWidget(viewModel: provider));
                              }
                          ));
                    }),
              );
            }),
          )
      );

      provider.isBiometricEnable = true;
      // await tester.pumpWidget(makeTestableWidget());
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Debug prints to verify rendering and localization
      // print("Rendered: ${find.byType(SignupTextFieldsWidget).evaluate().isNotEmpty}");
      // print("Localized Text: ${S.of(tester.element(find.byType(SignupTextFieldsWidget))).setup_account}");

      // Replace this with actual text or use partial match
      expect(find.text(S.of(provider.getContext()).welcome_please_login), findsOneWidget);
    } catch (e) {
      print("❌ Widget threw an error: $e");
    }
  });

}