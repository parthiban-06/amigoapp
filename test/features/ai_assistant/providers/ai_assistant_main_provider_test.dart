import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_main_provider.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await dotenv.load(fileName: "/Users/user/Documents/AmigoApp/.env.test");
  });
  late AiAssistantMainProvider provider;

  setUp(() {
    provider = AiAssistantMainProvider();
    // You may need to set context or mock dependencies for full coverage
  });

  test('Initial values are correct', () {
    expect(provider.currentPage, 0);
    expect(provider.nextPage, 0);
    expect(provider.teamSelectedIndex, 0);
    expect(provider.isAnimationFinished, isTrue);
    expect(provider.isTextAnimationFinished, isFalse);
    expect(provider.isGauageAnimationStart, isFalse);
    expect(provider.selectedGoalAnalytics, isEmpty);
    expect(provider.languageCode, 'en');
    expect(provider.isStepOneScreenShow, isTrue);
    expect(provider.isStepTwoScreenShow, isTrue);
    expect(provider.isStepThreeScreenShow, isTrue);
    expect(provider.isAllStepsEnabled, isTrue);
    expect(provider.showCancelButton, isFalse);
    expect(provider.showShowBackgroundGradient, isTrue);
  });

  testWidgets('setTextAnimationFinished updates isTextAnimationFinished',
      (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          provider.setContext(context);
          provider.setTextAnimationFinished(true);
          return Container();
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(provider.isTextAnimationFinished, isTrue);
  });

 
  testWidgets('isGauageAnimation updates isGauageAnimationStart', (tester) async {
  await tester.pumpWidget(
    Builder(
      builder: (context) {
        provider.setContext(context);
        provider.isGauageAnimation(false);
        expect(provider.isGauageAnimationStart, isFalse);
        provider.isGauageAnimation(true);
        expect(provider.isGauageAnimationStart, isTrue);
        return Container();
      },
    ),
  );
});
  testWidgets('showBackgroundGradient updates showShowBackgroundGradient',
      (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          provider.setContext(context);
          provider.showBackgroundGradient(false);
          expect(provider.showShowBackgroundGradient, isFalse);
          provider.showBackgroundGradient(true);
          expect(provider.showShowBackgroundGradient, isTrue);
          return Container();
        },
      ),
    );
  });
}
