import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_main_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_welcome_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/ai_assistant_welcome_screen.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:mockito/mockito.dart';

class MockAiAssistantWelcomeScreenProvider extends Mock implements AiAssistantWelcomeScreenProvider {}
class MockAiAssistantMainProvider extends Mock implements AiAssistantMainProvider {}
class MockFirebaseAnalyticsService extends Mock implements FirebaseAnalyticsService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAiAssistantWelcomeScreenProvider mockWelcomeProvider;
  late MockAiAssistantMainProvider mockMainProvider;

  setUp(() {
    mockWelcomeProvider = MockAiAssistantWelcomeScreenProvider();
    mockMainProvider = MockAiAssistantMainProvider();
    GetIt.I.reset();
    GetIt.I.registerSingleton<AiAssistantWelcomeScreenProvider>(mockWelcomeProvider);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        Provider<AiAssistantMainProvider>.value(value: mockMainProvider),
      ],
      child: const MaterialApp(
        home: AiAssistantWelcomeScreen(),
      ),
    );
  }

  testWidgets('renders AiAssistantWelcomeScreen and triggers analytics', (WidgetTester tester) async {
    when(mockMainProvider.isDesktopView).thenReturn(true);
    when(mockMainProvider.pages).thenReturn([]);
    when(mockWelcomeProvider.packageContents).thenReturn([]);
    when(mockWelcomeProvider.isDesktopView).thenReturn(true);
    when(mockWelcomeProvider.userModel).thenReturn(null);
    when(mockWelcomeProvider.isTabletWebFromBase).thenReturn(false);
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.byType(AiAssistantWelcomeScreen), findsOneWidget);
    expect(find.textContaining('Hi'), findsWidgets);
    expect(find.textContaining('Let'), findsWidgets); // Let’s get started button
  });

  testWidgets('navigates to common steps screen when pages is not empty', (WidgetTester tester) async {
    when(mockMainProvider.isDesktopView).thenReturn(true);
    when(mockMainProvider.pages).thenReturn([]);
    when(mockWelcomeProvider.packageContents).thenReturn([]);
    when(mockWelcomeProvider.isDesktopView).thenReturn(true);
    when(mockWelcomeProvider.userModel).thenReturn(null);
    when(mockWelcomeProvider.isTabletWebFromBase).thenReturn(false);
    var navigated = false;
    when(mockMainProvider.navigateToAiAssistantCommonStepsScreen()).thenAnswer((_) {
      navigated = true;
      return Future.value();
    });
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    final button = find.textContaining('Let');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(navigated, isTrue);
  });

  testWidgets('navigates to home screen when pages is empty', (WidgetTester tester) async {
    when(mockMainProvider.isDesktopView).thenReturn(true);
    when(mockMainProvider.pages).thenReturn([]);
    when(mockWelcomeProvider.packageContents).thenReturn([]);
    when(mockWelcomeProvider.isDesktopView).thenReturn(true);
    when(mockWelcomeProvider.userModel).thenReturn(null);
    when(mockWelcomeProvider.isTabletWebFromBase).thenReturn(false);
    var navigated = false;
    when(mockWelcomeProvider.navigateToHomeScreen()).thenAnswer((_) {
      navigated = true;
      return Future.value();
    });
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    final button = find.textContaining('Let');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(navigated, isTrue);
  });

  testWidgets('shows package details when packageContents is not empty', (WidgetTester tester) async {
    when(mockMainProvider.isDesktopView).thenReturn(true);
    when(mockMainProvider.pages).thenReturn([]);
    when(mockWelcomeProvider.packageContents).thenReturn(["Item 1", "Item 2"]);
    when(mockWelcomeProvider.isDesktopView).thenReturn(true);
    when(mockWelcomeProvider.userModel).thenReturn(null);
    when(mockWelcomeProvider.isTabletWebFromBase).thenReturn(false);
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
  });
}
