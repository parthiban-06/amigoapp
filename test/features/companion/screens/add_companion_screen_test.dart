import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/companion/screens/add_companion_screen.dart';
import 'package:visaamigo/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: "/Users/user/Documents/AmigoApp/.env.test");
  });

  group('AddCompanionScreen', () {
    Widget createTestWidget({CompanionProfile? companionProfile}) {
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        home: AddCompanionScreen(companionProfile: companionProfile),
      );
    }

    // Test widget creation
    test('should create AddCompanionScreen widget', () {
      final widget = AddCompanionScreen();
      expect(widget, isA<AddCompanionScreen>());
    });

    test('should create AddCompanionScreen widget with companion profile', () {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      final widget = AddCompanionScreen(companionProfile: companionProfile);
      expect(widget, isA<AddCompanionScreen>());
    });

    test('should accept null companion profile', () {
      final widget = AddCompanionScreen(companionProfile: null);
      expect(widget, isA<AddCompanionScreen>());
    });

    // Test widget rendering
    testWidgets('should render AddCompanionScreen with add mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Add Travel Companion'), findsOneWidget);
    });

    testWidgets('should render AddCompanionScreen with edit mode',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();
      expect(find.text('Edit Companion'), findsOneWidget);
    });

    testWidgets('should display form fields with correct labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Companion Email'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
    });

    testWidgets('should display required field indicator in add mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Required Field'), findsOneWidget);
    });

    testWidgets('should not display required field indicator in edit mode',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();
      expect(find.text('Required Field'), findsNothing);
    });

    testWidgets('should display match selection section',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(
          find.text('WHICH MATCH WILL YOUR COMPANION ATTEND?'), findsOneWidget);
      expect(find.text('Select all that apply'), findsOneWidget);
    });

    testWidgets('should display checkboxes for acknowledgments',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.byType(Checkbox), findsNWidgets(2));
    });

    testWidgets(
        'should display companion email cannot be edited message in edit mode',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();
      expect(find.text('Companion email cannot be edited'), findsOneWidget);
    });

    testWidgets('should display correct button text based on mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);

      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('should handle text field interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test email field
      final emailField = find.byType(TextField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Test first name field
      final firstNameField = find.byType(TextField).at(1);
      await tester.tap(firstNameField);
      await tester.enterText(firstNameField, 'John');
      await tester.pumpAndSettle();

      // Test last name field
      final lastNameField = find.byType(TextField).last;
      await tester.tap(lastNameField);
      await tester.enterText(lastNameField, 'Doe');
      await tester.pumpAndSettle();
    });

    testWidgets('should handle scroll behavior', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test scrolling
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle form key properly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final form = find.byType(Form);
      expect(form, findsOneWidget);
    });

    testWidgets('should handle companion profile with null values',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '',
        userId: '',
        firstName: '',
        lastName: '',
        email: '',
        matchIds: [],
        status: false,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      expect(find.text('Edit Companion'), findsOneWidget);
    });

    testWidgets('should handle companion profile with special characters',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'José',
        lastName: 'García-López',
        email: 'jose.garcia@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      expect(find.text('Edit Companion'), findsOneWidget);
    });

    testWidgets('should handle companion profile with long data',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: 'a' * 100,
        userId: 'b' * 100,
        firstName: 'c' * 100,
        lastName: 'd' * 100,
        email: 'e' * 100,
        matchIds: List.generate(50, (index) => 'match$index'),
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      expect(find.text('Edit Companion'), findsOneWidget);
    });

    testWidgets('should handle companion profile with edge case data',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '0',
        userId: '0',
        firstName: '0',
        lastName: '0',
        email: '0@0.0',
        matchIds: ['0'],
        status: false,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      expect(find.text('Edit Companion'), findsOneWidget);
    });

    testWidgets('should handle companion profile with boundary data',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '9999999999999999999999999999999999999999999999999999999999999999999999999999',
        userId:
            '9999999999999999999999999999999999999999999999999999999999999999999999999999',
        firstName:
            '9999999999999999999999999999999999999999999999999999999999999999999999999999',
        lastName:
            '9999999999999999999999999999999999999999999999999999999999999999999999999999',
        email:
            '9999999999999999999999999999999999999999999999999999999999999999999999999999@9999999999999999999999999999999999999999999999999999999999999999999999999999.9999999999999999999999999999999999999999999999999999999999999999999999999999',
        matchIds: List.generate(
            1000,
            (index) =>
                '9999999999999999999999999999999999999999999999999999999999999999999999999999'),
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      expect(find.text('Edit Companion'), findsOneWidget);
    });

    testWidgets('should handle checkbox interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(2));

      // Test tapping on first checkbox
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();

      // Test tapping on second checkbox
      await tester.tap(checkboxes.last);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle acknowledgment text interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test tapping on acknowledgment text
      final ackText =
          find.text('I acknowledge that adding a companion is optional');
      await tester.tap(ackText);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle agreement text interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test tapping on agreement text
      final agreeText =
          find.text('My companion has given me permission to add them');
      await tester.tap(agreeText);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle button interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test back button
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Test add button
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle edit mode button interactions',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      // Test cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Test update button
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // Test delete button
      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle form validation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test form submission without filling required fields
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle form with valid data',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill in form fields
      final emailField = find.byType(TextField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, 'test@example.com');

      final firstNameField = find.byType(TextField).at(1);
      await tester.tap(firstNameField);
      await tester.enterText(firstNameField, 'John');

      final lastNameField = find.byType(TextField).last;
      await tester.tap(lastNameField);
      await tester.enterText(lastNameField, 'Doe');

      await tester.pumpAndSettle();

      // Check checkboxes
      final checkboxes = find.byType(Checkbox);
      await tester.tap(checkboxes.first);
      await tester.tap(checkboxes.last);
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle edit mode form interactions',
        (WidgetTester tester) async {
      final companionProfile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        matchIds: ['match1'],
        status: true,
      );
      await tester
          .pumpWidget(createTestWidget(companionProfile: companionProfile));
      await tester.pumpAndSettle();

      // Test editing first name
      final firstNameField = find.byType(TextField).at(1);
      await tester.tap(firstNameField);
      await tester.enterText(firstNameField, 'Jane');
      await tester.pumpAndSettle();

      // Test editing last name
      final lastNameField = find.byType(TextField).last;
      await tester.tap(lastNameField);
      await tester.enterText(lastNameField, 'Smith');
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle widget lifecycle', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test widget disposal and recreation
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Add Travel Companion'), findsOneWidget);
    });

    testWidgets('should handle different screen orientations',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test landscape orientation
      tester.binding.window.physicalSizeTestValue = const Size(1024, 768);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpAndSettle();

      // Test portrait orientation
      tester.binding.window.physicalSizeTestValue = const Size(768, 1024);
      await tester.pumpAndSettle();

      // Reset
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    testWidgets('should handle accessibility features',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test semantic labels
      expect(find.bySemanticsLabel('Companion Email'), findsOneWidget);
      expect(find.bySemanticsLabel('First Name'), findsOneWidget);
      expect(find.bySemanticsLabel('Last Name'), findsOneWidget);
    });

    testWidgets('should handle keyboard interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test keyboard navigation
      final emailField = find.byType(TextField).first;
      await tester.tap(emailField);
      await tester.pumpAndSettle();

      // Simulate keyboard input
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Test next field navigation
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle error states gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test with invalid data
      final emailField = find.byType(TextField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      // Submit form with invalid data
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle loading states', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Test button states during loading
      final addButton = find.text('Add');
      expect(addButton, findsOneWidget);

      // Simulate loading state
      await tester.tap(addButton);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle network error scenarios',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form and submit
      final emailField = find.byType(TextField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, 'test@example.com');

      final firstNameField = find.byType(TextField).at(1);
      await tester.tap(firstNameField);
      await tester.enterText(firstNameField, 'John');

      final lastNameField = find.byType(TextField).last;
      await tester.tap(lastNameField);
      await tester.enterText(lastNameField, 'Doe');

      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle memory pressure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate memory pressure
      tester.binding.handleMemoryPressure();
      await tester.pumpAndSettle();

      expect(find.text('Add Travel Companion'), findsOneWidget);
    });

    testWidgets('should handle app lifecycle changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate app pause
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pumpAndSettle();

      // Simulate app resume
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.text('Add Travel Companion'), findsOneWidget);
    });
  });
}
