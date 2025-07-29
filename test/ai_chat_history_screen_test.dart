import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_history.dart'
    show AiChatHistory;
import 'package:visaamigo/features/ai_assistant/providers/ai_hisotry/ai_chat_hisotry_provider.dart'
    show AiChatHistoryProvider;
import 'package:visaamigo/features/ai_assistant/screens/ai_history/ai_chat_history_screen.dart'
    show AiChatHistoryScreen;
import 'package:visaamigo/utils/responsive_util.dart';

// Mock Provider
class MockAiChatHistoryProvider extends Mock implements AiChatHistoryProvider {}

class MockResponsiveUtil extends Mock implements ResponsiveUtil {}

void main() {
  late MockAiChatHistoryProvider mockProvider;
  late MockResponsiveUtil mockResponsiveUtil;

  setUp(() {
    mockProvider = MockAiChatHistoryProvider();
    mockResponsiveUtil = MockResponsiveUtil();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AiChatHistoryProvider>.value(
            value: mockProvider),
        Provider<ResponsiveUtil>.value(value: mockResponsiveUtil),
      ],
      child: MaterialApp(
        home: Scaffold(body: AiChatHistoryScreen()),
      ),
    );
  }

  testWidgets("Renders the Chat History Screen correctly",
      (WidgetTester tester) async {
    when(mockProvider.chatHistory).thenReturn(["Chat 1", "Chat 2", "Chat 3"]);
    when(mockProvider.isDeleteHistoryEnable).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Rebuild the widgets

    expect(find.byType(AiChatHistory), findsOneWidget);
    expect(find.text("Chat 1"), findsOneWidget);
    expect(find.text("Chat 2"), findsOneWidget);
    expect(find.text("Chat 3"), findsOneWidget);
  });

  testWidgets("Toggles delete UI when onCancelPress is triggered",
      (WidgetTester tester) async {
    when(mockProvider.isDeleteHistoryEnable).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.byType(VisaAppBar));
    await tester.pump();

    verify(mockProvider.showDeleteChatUi()).called(1);
  });

  testWidgets("Displays delete button when delete mode is enabled",
      (WidgetTester tester) async {
    when(mockProvider.isDeleteHistoryEnable).thenReturn(true);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text("Delete"), findsOneWidget);
  });
}
