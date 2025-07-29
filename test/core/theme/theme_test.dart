import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/core/theme/theme.dart';

void main() {
  group('VisaColors Tests', () {
    group('Brand Theme Colors', () {
      test('should have correct primary colors', () {
        expect(VisaColors.primaryDark, equals(const Color(0xFF021E4C)));
        expect(VisaColors.primary, equals(const Color(0xFF1434CB)));
        expect(VisaColors.primary2, equals(const Color(0xFF1534CC)));
        expect(VisaColors.primaryLight, equals(const Color(0xFF3B57DE)));
        expect(VisaColors.primaryLight2, equals(const Color(0xFF2B94F5)));
      });

      test('should have correct secondary colors', () {
        expect(VisaColors.secondaryDark, equals(const Color(0xFFF7B600)));
        expect(VisaColors.secondary, equals(const Color(0xFFFCC015)));
        expect(VisaColors.secondaryLight, equals(const Color(0xFFFFD700)));
      });
    });

    group('Dark Theme Colors', () {
      test('should have correct dark primary colors', () {
        expect(VisaColors.darkPrimaryDark, equals(const Color(0xFF000000)));
        expect(VisaColors.darkPrimary, equals(const Color(0xFF163049)));
        expect(VisaColors.darkPrimaryLight, equals(const Color(0xFF2C445C)));
      });

      test('should have correct dark secondary colors', () {
        expect(VisaColors.darkSecondaryDark, equals(const Color(0xFFDFB357)));
        expect(VisaColors.darkSecondary, equals(const Color(0xFFE1B96E)));
        expect(VisaColors.darkSecondaryLight, equals(const Color(0xFFE8C887)));
      });
    });

    group('Text Colors', () {
      test('should have correct text colors', () {
        expect(VisaColors.textTertiary5, equals(const Color(0xFF666666)));
        expect(VisaColors.textTertiary7, equals(const Color(0xFF333333)));
        expect(VisaColors.textFieldBorder, equals(const Color(0xFF767676)));
        expect(VisaColors.chatTextColor, equals(const Color(0xFF1A1A1A)));
        expect(VisaColors.shimmerGrey, equals(const Color(0xFF2E2E2E)));
        expect(VisaColors.webViewGrey, equals(const Color(0xFF505050)));
      });

      test('should have correct basic colors', () {
        expect(VisaColors.white, equals(Colors.white));
        expect(VisaColors.black, equals(Colors.black));
      });
    });

    group('Tertiary Colors', () {
      test('should have correct tertiary colors', () {
        expect(VisaColors.tertiary5, equals(const Color(0xFFE0E0E0)));
        expect(VisaColors.greyBackGround, equals(const Color(0xFFF0EFEF)));
        expect(VisaColors.tertiary7, equals(const Color(0xFFC0C0C0)));
        expect(VisaColors.grey, equals(const Color(0xFF9E9E9E)));
      });

      test('should have correct status colors', () {
        expect(VisaColors.error, equals(const Color(0xFFD92A3C)));
        expect(VisaColors.red, equals(const Color(0xFFD65168)));
        expect(VisaColors.green, equals(const Color(0xFF40996B)));
      });
    });

    group('Common Colors', () {
      test('should have correct common colors', () {
        expect(VisaColors.greyLight, equals(const Color(0xFFF0F0F0)));
        expect(VisaColors.transparent, equals(Colors.transparent));
        expect(VisaColors.blueLight, equals(const Color(0XFF97C7E8)));
        expect(VisaColors.greyDotLight, equals(const Color(0xFFDDDDDD)));
        expect(VisaColors.blueTextLight, equals(const Color(0xFF408DFF)));
        expect(VisaColors.blueBackgroundLight, equals(const Color(0xFFC2EBFF)));
        expect(
            VisaColors.blueBackgroundLight2, equals(const Color(0xFFE7F7FF)));
      });
    });

    group('Gradient Colors', () {
      test('should have correct selected gradient colors', () {
        expect(VisaColors.selectedFirstLayerGradientColor,
            equals(const Color(0xFFF9C941)));
        expect(VisaColors.selectedSecondLayerGradientColor,
            equals(const Color(0xFFFFDD68)));
        expect(VisaColors.selectedThirdLayerGradientColor,
            equals(const Color(0xFFFFEEA0)));
        expect(VisaColors.selectedBlurColor, equals(const Color(0x4CFCC014)));
      });

      test('should have correct unselected gradient colors', () {
        expect(VisaColors.unSelectedFirstLayerGradientColor,
            equals(const Color(0xFFB6ECEB)));
        expect(VisaColors.unSelectedSecondLayerGradientColor,
            equals(const Color(0xFF9ACBF6)));
        expect(VisaColors.unSelectedThirdLayerGradientColor,
            equals(const Color(0xFF8EBDFF)));
        expect(VisaColors.unSelectedBlurColor, equals(const Color(0x3390BFFB)));
      });
    });

    group('Special Purpose Colors', () {
      test('should have correct special purpose colors', () {
        expect(
            VisaColors.greyScrollTrackColor, equals(const Color(0xFFDCDBDB)));
        expect(VisaColors.weatherCardColor, equals(const Color(0xFFEAF4FE)));
        expect(VisaColors.weatherCardTextGreyColor,
            equals(const Color(0xFF969696)));
        expect(VisaColors.bookingBadgeColor, equals(const Color(0xFF021E4C)));
        expect(VisaColors.dividerColor, equals(const Color(0xFF767676)));
        expect(VisaColors.starYellowColor, equals(const Color(0xFFFCC015)));
        expect(VisaColors.dialogBgColor, equals(const Color(0xFFFBEEF0)));
        expect(VisaColors.bookingCardColor, equals(const Color(0xFF003B95)));
        expect(VisaColors.lightRed, equals(const Color(0xFFFBEEF0)));
        expect(VisaColors.ratingTextColor, equals(const Color(0xFFFFFEFF)));
        expect(VisaColors.tutorialBgColor, equals(const Color(0xFF021E4C)));
        expect(VisaColors.hotelCardBgColor, equals(const Color(0xFFD9D9D9)));
        expect(
            VisaColors.hotelCardEmptyBgColor, equals(const Color(0xFFEFEFEF)));
      });
    });

    group('Color Properties', () {
      test('should have valid color values', () {
        // Test that all colors are valid (not null and have proper alpha values)
        final colors = [
          VisaColors.primaryDark,
          VisaColors.primary,
          VisaColors.secondary,
          VisaColors.white,
          VisaColors.black,
          VisaColors.error,
          VisaColors.green,
        ];

        for (final color in colors) {
          expect(color, isNotNull);
          expect(color.alpha, greaterThanOrEqualTo(0));
          expect(color.alpha, lessThanOrEqualTo(255));
        }
      });

      test('should have consistent color relationships', () {
        // Test that light colors are lighter than dark colors
        expect(VisaColors.primaryLight.value,
            greaterThan(VisaColors.primaryDark.value));
        expect(VisaColors.secondaryLight.value,
            greaterThan(VisaColors.secondaryDark.value));
      });
    });
  });

  group('VisaTheme Tests', () {
    group('Light Theme', () {
      test('should have correct light theme properties', () {
        final theme = VisaTheme.lightTheme;

        expect(theme.useMaterial3, isTrue);
        expect(theme.brightness, equals(Brightness.light));
        expect(theme.splashColor, equals(Colors.transparent));
        expect(theme.highlightColor, equals(Colors.transparent));
      });

      test('should have correct light theme color scheme', () {
        final colorScheme = VisaTheme.lightTheme.colorScheme;

        expect(colorScheme.brightness, equals(Brightness.light));
        expect(colorScheme.primary, equals(VisaColors.primary));
        expect(colorScheme.onPrimary, equals(VisaColors.white));
        expect(colorScheme.secondary, equals(VisaColors.secondary));
        expect(colorScheme.onSecondary, equals(VisaColors.black));
        expect(colorScheme.error, equals(VisaColors.error));
        expect(colorScheme.onError, equals(VisaColors.white));
        expect(colorScheme.background, equals(VisaColors.white));
        expect(colorScheme.onBackground, equals(VisaColors.black));
        expect(colorScheme.surface, equals(VisaColors.white));
        expect(colorScheme.onSurface, equals(VisaColors.black));
      });

      test('should have correct text theme', () {
        final textTheme = VisaTheme.lightTheme.textTheme;
        expect(textTheme, isNotNull);
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodySmall, isNotNull);
      });
    });

    group('Dark Theme', () {
      test('should have correct dark theme properties', () {
        final theme = VisaTheme.darkTheme;

        expect(theme.useMaterial3, isTrue);
        expect(theme.brightness, equals(Brightness.dark));
        expect(theme.splashColor, equals(Colors.transparent));
        expect(theme.highlightColor, equals(Colors.transparent));
      });

      test('should have correct dark theme color scheme', () {
        final colorScheme = VisaTheme.darkTheme.colorScheme;

        expect(colorScheme.brightness, equals(Brightness.dark));
        expect(colorScheme.primary, equals(VisaColors.darkPrimary));
        expect(colorScheme.onPrimary, equals(VisaColors.white));
        expect(colorScheme.secondary, equals(VisaColors.darkSecondary));
        expect(colorScheme.onSecondary, equals(VisaColors.black));
        expect(colorScheme.error, equals(VisaColors.error));
        expect(colorScheme.onError, equals(VisaColors.white));
        expect(colorScheme.background, equals(VisaColors.darkPrimaryDark));
        expect(colorScheme.onBackground, equals(VisaColors.white));
        expect(colorScheme.surface, equals(VisaColors.darkPrimary));
        expect(colorScheme.onSurface, equals(VisaColors.white));
      });

      test('should have correct text theme', () {
        final textTheme = VisaTheme.darkTheme.textTheme;
        expect(textTheme, isNotNull);
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodySmall, isNotNull);
      });
    });

    group('Theme Consistency', () {
      test('should have consistent theme structure', () {
        final lightTheme = VisaTheme.lightTheme;
        final darkTheme = VisaTheme.darkTheme;

        // Both themes should have the same basic structure
        expect(lightTheme.useMaterial3, equals(darkTheme.useMaterial3));
        expect(lightTheme.splashColor, equals(darkTheme.splashColor));
        expect(lightTheme.highlightColor, equals(darkTheme.highlightColor));

        // But different brightness
        expect(lightTheme.brightness, isNot(equals(darkTheme.brightness)));
      });

      test('should have valid color schemes', () {
        final lightColorScheme = VisaTheme.lightTheme.colorScheme;
        final darkColorScheme = VisaTheme.darkTheme.colorScheme;

        // Test that color schemes are valid
        expect(lightColorScheme.primary, isNotNull);
        expect(lightColorScheme.onPrimary, isNotNull);
        expect(darkColorScheme.primary, isNotNull);
        expect(darkColorScheme.onPrimary, isNotNull);
      });
    });
  });
}
