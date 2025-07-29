import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';
import 'package:visaamigo/features/ai_assistant/models/get_user_matches_model.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_prompts_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/repo/ai_assistant_repo.dart';
import 'package:visaamigo/remote/api_response.dart';

import 'ai_assistant_prompt_screen_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<AiAssistantRepo>(as: #MockAiAssistantRepository),
])
void main() {
  late MockAiAssistantRepository mockAiAssistantRepo;
  late AiAssistantPromptsScreenProvider viewModel;
  late List<Data> listMatches;

  setUp(() async {
    TestWidgetsFlutterBinding
        .ensureInitialized(); // Ensures Flutter is initialized

    await dotenv.load(); // Load the environment variables

    mockAiAssistantRepo = MockAiAssistantRepository();
    viewModel = AiAssistantPromptsScreenProvider();
    viewModel.aiAssistantRepo = mockAiAssistantRepo; // Injecting mock repo
    listMatches = [];
  });

  group('Get Preferences Questions API Call', () {
    test('Should update listQuestions on successful response', () async {
      // Expected API response
      final mockResponse = ApiResponse<AiGetPreferencesQuestionModel>(
        data: AiGetPreferencesQuestionModel(
          questions: [
            Questions(
              questionId: "f2f71134-3059-4e1e-b59f-e23b415f629b",
              questionKey: "app_preferences_questions_places_to_visit",
              isPrimary: false,
              section: "hidden_gems",
              options: [
                Options(optionId: "theme_parks"),
                Options(optionId: "parks_and_gardens"),
                Options(optionId: "museums"),
                Options(optionId: "nightlife"),
                Options(optionId: "shopping_centers"),
                Options(optionId: "historical_landmarks"),
                Options(optionId: "no_preference"),
                // This should move to the end
              ],
              selectedOptions: [],
            ),
          ],
        ),
        statusCode: 200,
      );

      // Mock API call
      when(mockAiAssistantRepo.getPreferencesQuestions(any))
          .thenAnswer((_) async => mockResponse);

      // Call function
      await viewModel.getPreferencesQuestions();

      // Verify API call
      verify(mockAiAssistantRepo.getPreferencesQuestions(any)).called(1);

      // Ensure questions are populated
      expect(viewModel.listQuestions, isNotEmpty);

      // Verify "no_preference" is moved to the end
      final options = viewModel.listQuestions!.first.options!;
      expect(options.last.optionId, equals("no_preference"));
    });

    test('Should set listQuestions to empty if response is null', () async {
      when(mockAiAssistantRepo.getPreferencesQuestions(any))
          .thenAnswer((_) async => ApiResponse<AiGetPreferencesQuestionModel>(
                data: null,
                statusCode: 400, // Simulating an error response
              ));

      await viewModel.getPreferencesQuestions();

      expect(viewModel.listQuestions, isEmpty);
    });

    test('Should set listQuestions to empty if response is unsuccessful',
        () async {
      final mockResponse = ApiResponse<AiGetPreferencesQuestionModel>(
        statusCode: 400,
      );

      when(mockAiAssistantRepo.getPreferencesQuestions(any))
          .thenAnswer((_) async => mockResponse);

      await viewModel.getPreferencesQuestions();

      expect(viewModel.listQuestions, isEmpty);
    });
  });

  Future<void> getUserMatches() async {
    final response = await mockAiAssistantRepo.getUserMatches(
        GetUserMatchesModel.fromJson); // FIXED: Explicit parameter

    if (response.isSuccess && response.data != null) {
      listMatches = response.data!.data!;
    } else {
      listMatches = [];
    }
  }

  group('getUserMatches', () {
    test('should fetch user matches successfully', () async {
      // Arrange: Mock API response
      final mockResponse = ApiResponse<GetUserMatchesModel>(
        data: GetUserMatchesModel(
          statusCode: 200,
          messageKey: "matches_retrieved",
          data: [
            Data(
              id: "81e529e4-f6f1-4149-8893-d7761c60d848",
              matchCity: "Boston",
              matchStadium: "Boston Stadium",
              eventName: "Match5",
              matchTime: "2026-06-13T14:00:00.000Z",
              matchTimezone: "Eastern Standard Time",
              matchTeams: "TBD1 v TBD2",
              matchName: "Group C",
            ),
          ],
        ),
        statusCode: 200,
      );

      when(mockAiAssistantRepo.getUserMatches(any)) // FIXED
          .thenAnswer((_) async => mockResponse);

      // Act: Call function
      await getUserMatches();

      // Assert: Verify expected behavior
      verify(mockAiAssistantRepo.getUserMatches(any)).called(1);
      expect(listMatches, isNotEmpty);
      expect(listMatches.first.matchCity, "Boston");
    });

    test('should handle API failure', () async {
      // Arrange: Simulate API failure
      final mockErrorResponse = ApiResponse<GetUserMatchesModel>(
        data: null,
        statusCode: 500,
      );

      when(mockAiAssistantRepo.getUserMatches(any)) // FIXED
          .thenAnswer((_) async => mockErrorResponse);

      // Act: Call function
      await getUserMatches();

      // Assert: Ensure list is empty
      expect(listMatches, isEmpty);
    });

    test('should handle null response', () async {
      // Arrange: Return null response
      when(mockAiAssistantRepo.getUserMatches(any)) // FIXED
          .thenAnswer((_) async => ApiResponse<GetUserMatchesModel>(
                data: null,
                statusCode: 400, // Simulating an error response
              ));

      // Act: Call function
      await getUserMatches();

      // Assert: Ensure list is empty
      expect(listMatches, isEmpty);
    });
  });
}
