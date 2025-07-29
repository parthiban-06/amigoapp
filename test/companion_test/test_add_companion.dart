import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';
import 'package:visaamigo/features/companion/providers/add_companion_provider.dart';
import 'package:visaamigo/remote/api_response.dart';

import '../test_ui/registered_email.mocks.dart';

void main() {
  late AddCompanionProvider viewModel;
  late MockUserDetailRepo mockUserDetailRepo;

  setUp(() async {
    TestWidgetsFlutterBinding
        .ensureInitialized(); // Ensures Flutter is initialized

    await dotenv.load(fileName: "config/dev/.env");

    mockUserDetailRepo = MockUserDetailRepo();
    viewModel = AddCompanionProvider();
  });

  test('Should add companion successfully when inputs are valid', () async {
    // Setup
    viewModel.firstName.text = 'John';
    viewModel.lastName.text = 'Doe';
    viewModel.email.text = 'john.doe@example.com';
    viewModel.isEdit = false;
    viewModel.isDisable = false;
    viewModel.iAcknowledge = true;
    viewModel.iAgree = true;
    viewModel.matchList = [
      Options(optionId: 'match1', isSelected: true),
    ];

    when(mockUserDetailRepo.addCompanion((json) => (), any)).thenAnswer(
        (_) async => ApiResponse(statusCode: 200, messageKey: 'success'));

    expect(viewModel.isLoading, false);
    expect(viewModel.showIAcknowledgeIAgreeError, false);
    expect(viewModel.showMatchListError, false);
  });

  test('Should show matchList error if no match selected', () async {
    viewModel.firstName.text = 'John';
    viewModel.lastName.text = 'Doe';
    viewModel.email.text = 'john.doe@example.com';
    viewModel.isEdit = false;
    viewModel.isDisable = false;
    viewModel.iAcknowledge = true;
    viewModel.iAgree = true;
    viewModel.matchList = [];

    verifyNever(mockUserDetailRepo.addCompanion((json) => (), any));
  });

  test('Should show agreement error if terms not accepted', () async {
    viewModel.firstName.text = 'John';
    viewModel.lastName.text = 'Doe';
    viewModel.email.text = 'john.doe@example.com';
    viewModel.isEdit = false;
    viewModel.isDisable = false;
    viewModel.iAcknowledge = false; // not agreed
    viewModel.iAgree = false;
    viewModel.matchList = [Options(optionId: 'match1', isSelected: true)];

    verifyNever(mockUserDetailRepo.addCompanion((json) => (), any));
  });
}
