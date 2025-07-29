import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_main_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_threads_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:visaamigo/features/home/providers/animated_bottom_bar_provider.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/login/view/login_view.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/proivder/theme_provider.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart' show ThemeProvider;
import 'package:visaamigo/ui/userdashboard/user_dashboard_provider.dart';
import 'package:visaamigo/utils/Inactive_session.dart';
import 'package:visaamigo/utils/responsive_util.dart';

void main() {
  setUpAll(() async {
    // await appConfig(); // Ensure .env file is loaded
  });
  testWidgets('Login screen UI test', (WidgetTester tester) async {
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
                  // Regular Visa brand theme
                  darkTheme: VisaTheme.lightTheme,
                  // Affluent theme
                  themeMode: Provider.of<ThemeProvider>(context).themeMode,
                  home: LoginView(
                      UserModel(email: "ayush.chauhan@trantorinc.com")));
            }),
          );
        }),
      ),
    );

    // Verify UI components exist
    expect(find.byKey(Key('emailField')), findsOneWidget);
    expect(find.byKey(Key('passwordField')), findsOneWidget);
    expect(find.byKey(Key('loginButton')), findsOneWidget);

    // Enter email and password
    await tester.enterText(
        find.byKey(Key('emailField')), 'ayush.chauhan@trantorinc.com');
    await tester.pump();
    await tester.enterText(find.byKey(Key('passwordField')), 'Ayush@123');
    await tester.pump();

    // Verify input values
    expect(find.text('ayush.chauhan@trantorinc.com'), findsOneWidget);
    expect(find.text('Ayush@123'),
        findsOneWidget); // Visible in the test, but will be hidden in UI.

    // Tap the login button
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pump();

    // You can add additional expectations here based on button action
  });
}
