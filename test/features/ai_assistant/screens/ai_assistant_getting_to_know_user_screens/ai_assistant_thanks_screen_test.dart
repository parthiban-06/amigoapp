import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_welcome_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/ai_assistant_thanks_screen.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockAiAssistantWelcomeScreenProvider extends Mock implements AiAssistantWelcomeScreenProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAiAssistantWelcomeScreenProvider mockWelcomeProvider;

  setUp(() {
    mockWelcomeProvider = MockAiAssistantWelcomeScreenProvider();
    GetIt.I.reset();
    GetIt.I.registerSingleton<AiAssistantWelcomeScreenProvider>(mockWelcomeProvider);
    when(mockWelcomeProvider.userModel).thenReturn(null);
    when(mockWelcomeProvider.init()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      home: const AiAssistantThanksScreen(),
    );
  }

  testWidgets('renders thanks screen and displays expected text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.byType(AiAssistantThanksScreen), findsOneWidget);
    expect(find.textContaining('Thanks'), findsWidgets);
    expect(find.textContaining('Continue'), findsWidgets);
  });

  testWidgets('calls navigateToHomeScreen when continue button is pressed', (tester) async {
    var navigated = false;
    when(mockWelcomeProvider.navigateToHomeScreen()).thenAnswer((_) async {
      navigated = true;
    });
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    final button = find.textContaining('Continue');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(navigated, isTrue);
  });

  testWidgets('displays user first name if userModel is not null', (tester) async {
    // Use a real or minimal UserModel with firstName property if available
    // Use a real UserModel with firstName property
    final fakeUser = UserModel(firstName: 'alex');
    when(mockWelcomeProvider.userModel).thenReturn(fakeUser);
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    // UserModel getter capitalizes first letter
    expect(find.textContaining('Alex'), findsWidgets);
  });



}
