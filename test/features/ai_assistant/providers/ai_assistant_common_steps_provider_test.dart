import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_common_steps_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await dotenv.load(fileName: "/Users/user/Documents/AmigoApp/.env.test");
  });
  late AiAssistantCommonStepsProvider provider;

  setUp(() {
    provider = AiAssistantCommonStepsProvider();
  });

  test('Initial values are correct', () {
    expect(provider.currentStep, 1);
    expect(provider.isContinueClick, isFalse);
  });

  test('setCurrentStep updates currentStep and notifies listeners', () {
    bool notified = false;
    provider.addListener(() {
      notified = true;
    });
    provider.setCurrentStep(3);
    expect(provider.currentStep, 3);
    expect(notified, isTrue);
  });

  testWidgets('setContinueClick works with context', (WidgetTester tester) async {
    final provider = AiAssistantCommonStepsProvider();

    // Build a minimal widget to get a BuildContext
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          provider.setContext(context); // Set the context
          return Container();
        },
      ),
    );

    provider.setContinueClick(true);
    expect(provider.isContinueClick, isTrue);

    provider.setContinueClick(false);
    expect(provider.isContinueClick, isFalse);
  });
}
