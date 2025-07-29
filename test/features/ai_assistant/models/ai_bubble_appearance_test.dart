import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_bubble_appearance.dart';


void main() {
  group('BubbleAppearance', () {
    test('constructor assigns all fields correctly', () {
      const double size = 24.0;
      const double fontSize = 16.0;
      final textStyle = VisaTextStyle.bodyMedium;
      const bool isSurrounding = true;

      final appearance = BubbleAppearance(
        size: size,
        fontSize: fontSize,
        textStyle: textStyle,
        isSurrounding: isSurrounding,
      );

      expect(appearance.size, size);
      expect(appearance.fontSize, fontSize);
      expect(appearance.textStyle, textStyle);
      expect(appearance.isSurrounding, isSurrounding);
    });

    test('supports different VisaTextStyle values', () {
      final appearance = BubbleAppearance(
        size: 10,
        fontSize: 8,
        textStyle: VisaTextStyle.displayLarge,
        isSurrounding: false,
      );
      expect(appearance.textStyle, VisaTextStyle.displayLarge);
      expect(appearance.isSurrounding, isFalse);
    });

    test('equality and hashCode', () {
      final a1 = BubbleAppearance(
        size: 1,
        fontSize: 2,
        textStyle: VisaTextStyle.bodyMedium,
        isSurrounding: true,
      );
      final a2 = BubbleAppearance(
        size: 1,
        fontSize: 2,
        textStyle: VisaTextStyle.bodyMedium,
        isSurrounding: true,
      );
      expect(a1, isNot(same(a2))); // Not the same instance
      expect(a1.size, a2.size);
      expect(a1.fontSize, a2.fontSize);
      expect(a1.textStyle, a2.textStyle);
      expect(a1.isSurrounding, a2.isSurrounding);
    });
  });
}
