import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_items_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_response.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_search_places_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_weather_forecast_model.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:visaamigo/features/ai_assistant/repo/ai_assistant_repo.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/ai_message.dart';
import 'package:visaamigo/remote/api_response.dart';

import 'ai_chat_screen_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<AiAssistantRepo>(as: #MockChatRepository),
])
void main() {
  late MockChatRepository mockChatRepository;
  late ChatProvider provider;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(); // Only if dotenv is required by your code

    mockChatRepository = MockChatRepository();
    provider = ChatProvider();
    provider.aiAssistantRepo = mockChatRepository;

    // Universal stub to avoid MissingStubError
    when(mockChatRepository.submitMessageFeedback(any, any))
        .thenAnswer((_) async => ApiResponse<AiChatResponse>(
              data: null,
              statusCode: 200,
            ));
  });

  group('Fetch AI Assistant Responses API Call', () {
    test('Should return valid AiChatResponse with proper nested data',
        () async {
      const message = "What should I do in Tokyo?";
      const sessionId = "test-session-id";

      final place = Place(
        id: "place123",
        internationalPhoneNumber: "+81 90-1234-5678",
        formattedAddress: "Shibuya, Tokyo",
        rating: 4.7,
        googleMapsUri: "https://maps.google.com/?q=Shibuya",
        displayName: "Shibuya Crossing",
        photos: ["https://example.com/photo1.jpg"],
        location: null,
        shortFormattedAddress: '',
        editorialSummary: null,
        isExpand: false,
        primaryType: '',
        openNow: true,
        timings: '',
      );

      final forecast = WeatherForecast(
        date: "2025-04-07",
        icon: "sunny",
        weatherType: "Sunny",
        tempF: 75.0,
        precipChance: 0.0,
        windMph: 5.0,
        maxTempF: 78.0,
        minTempF: 68.0,
        maxTempC: 25.5,
        minTempC: 20.0,
      );

      final aiChatItems = AiChatItems(
        location: "Tokyo",
        forecast: [forecast],
        places: [place],
      );

      final datum = Datum(
        source: "AI",
        tag: "travel_suggestion",
        items: aiChatItems,
      );

      final chatResponse = AiChatResponse(
        type: "travel",
        initialText: "Let me think...",
        finalText: "Here's what I recommend in Tokyo!",
        data: [datum],
        topic: "tokyo_travel",
        sessionId: sessionId,
        messageId: "msg-20250407",
      );

      final mockApiResponse = ApiResponse<AiChatResponse>(
        data: chatResponse,
        statusCode: 200,
      );

      /// Use [argThat] to match the map with expected keys/values
      when(mockChatRepository.getMessage(
        argThat(predicate<Map<String, dynamic>>(
            (map) => map["query"] == message && map["city"] == "Tokyo")),
        any,
      )).thenAnswer((_) async => mockApiResponse);

      provider.userLocation = "Tokyo";
      provider.sessionId = "";

      final result = await provider.fetchResponsesFromServer(message);

      // Assertions
      expect(result, isNotNull);
      expect(result?.sessionId, sessionId);
      expect(result?.data.first.items.location, "Tokyo");
      expect(result?.data.first.items.places.first.displayName,
          contains("Shibuya"));
      expect(
          result?.data.first.items.forecast.first.weatherType, equals("Sunny"));

      verify(mockChatRepository.getMessage(any, any)).called(1);
    });

    test('Should return null if response is null or not successful', () async {
      const message = "Hi";

      // Stub for invalid/null response
      when(mockChatRepository.getMessage(any, any)).thenAnswer((_) async =>
          ApiResponse<AiChatResponse>(data: null, statusCode: 400));

      final result1 = await provider.fetchResponsesFromServer(message);

      expect(result1, isNull);

      // Stub for error response
      when(mockChatRepository.getMessage(any, any)).thenAnswer((_) async =>
          ApiResponse<AiChatResponse>(data: null, statusCode: 500));

      final result2 = await provider.fetchResponsesFromServer("Hello");

      expect(result2, isNull);
    });
  });

  group('Submit Message Feedback', () {
    const validSessionId = "session-123";
    const validMessageId = "msg-456";

    test('Should send "like" feedback with correct session and message IDs',
        () async {
      const feedback = "like";

      final expectedPayload = {
        "feedback": feedback,
        "message_id": validMessageId,
        "session_id": validSessionId,
      };

      when(mockChatRepository.submitMessageFeedback(expectedPayload, any))
          .thenAnswer((_) async => ApiResponse<AiChatResponse>(
                data: null,
                statusCode: 200,
              ));

      final result = await provider.submitMessageFeedback(
          feedback, validSessionId, validMessageId);

      expect(result, isNull);
      verify(mockChatRepository.submitMessageFeedback(expectedPayload, any))
          .called(1);
    });

    test('Should send "dislike" feedback with correct session and message IDs',
        () async {
      const feedback = "dislike";

      final expectedPayload = {
        "feedback": feedback,
        "message_id": validMessageId,
        "session_id": validSessionId,
      };

      when(mockChatRepository.submitMessageFeedback(expectedPayload, any))
          .thenAnswer((_) async => ApiResponse<AiChatResponse>(
                data: null,
                statusCode: 200,
              ));

      final result = await provider.submitMessageFeedback(
          feedback, validSessionId, validMessageId);

      expect(result, isNull);
      verify(mockChatRepository.submitMessageFeedback(expectedPayload, any))
          .called(1);
    });

    test('Should not call submitMessageFeedback if messageId is empty',
        () async {
      const feedback = "like";
      const emptyMessageId = "";

      final result = await provider.submitMessageFeedback(
          feedback, validSessionId, emptyMessageId);

      expect(result, isNull);
      verifyNever(mockChatRepository.submitMessageFeedback(any, any));
    });

    test('Should not call submitMessageFeedback for invalid feedback',
        () async {
      final result = await provider.submitMessageFeedback(
        "neutral", // Invalid feedback
        "session-123",
        "msg-456",
      );

      expect(result, isNull);

      // Verify it was never called
      verifyNever(mockChatRepository.submitMessageFeedback(any, any));
    });
  });

  group('updateLikeDislike()', () {
    bool setStateCalled = true;

    test('Like from neutral (0 → 1)', () {
      final msg = Message(
          id: '1',
          state: 0,
          text: '',
          isUser: true,
          timestamp: DateTime.now(),
          aiChatResponse: null,
          editId: '');
      provider.messages.add(msg);

      provider.updateLikeDislike('1', 0, true);

      expect(provider.messages.first.state, 1);
      expect(setStateCalled, true);
    });

    test('Undo like (1 → 0)', () {
      final msg = Message(
          id: '2',
          state: 1,
          text: '',
          isUser: true,
          timestamp: DateTime.now(),
          aiChatResponse: null,
          editId: '');
      provider.messages.add(msg);

      provider.updateLikeDislike('2', 1, true);

      expect(provider.messages.first.state, 0);
    });

    test('Switch dislike to like (2 → 1)', () {
      final msg = Message(
          id: '3',
          state: 2,
          text: '',
          isUser: true,
          timestamp: DateTime.now(),
          aiChatResponse: null,
          editId: '');
      provider.messages.add(msg);

      provider.updateLikeDislike('3', 2, true);

      expect(provider.messages.first.state, 1);
    });

    test('Dislike from like (1 → 2)', () {
      final msg = Message(
          id: '4',
          state: 1,
          text: '',
          isUser: true,
          timestamp: DateTime.now(),
          aiChatResponse: null,
          editId: '');
      provider.messages.add(msg);

      provider.updateLikeDislike('4', 1, false);

      expect(provider.messages.first.state, 2);
    });

    test('Undo dislike (2 → 0)', () {
      final msg = Message(
          id: '5',
          state: 2,
          text: '',
          isUser: true,
          timestamp: DateTime.now(),
          aiChatResponse: null,
          editId: '');
      provider.messages.add(msg);

      provider.updateLikeDislike('5', 2, false);

      expect(provider.messages.first.state, 0);
    });

    test('Dislike from neutral (0 → 2)', () {
      final msg = Message(
          id: '6',
          state: 0,
          text: '',
          isUser: true,
          timestamp: DateTime.now(),
          aiChatResponse: null,
          editId: '');
      provider.messages.add(msg);

      provider.updateLikeDislike('6', 0, false);

      expect(provider.messages.first.state, 2);
    });
  });
}
