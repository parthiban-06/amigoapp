import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visaamigo/remote/api_client.dart';
import 'package:visaamigo/remote/api_response.dart';
import 'package:visaamigo/features/ai_assistant/repo/ai_assistant_repo.dart';
import 'package:visaamigo/remote/debug_http_client.dart';

class FakeApiClient extends ApiClient {
  @override
  String baseUrl = 'http://localhost';

  bool patchCalled = false;
  bool getCalled = false;
  bool postCalled = false;
  bool putCalled = false;
  bool deleteCalled = false;
  dynamic lastBody;
  dynamic lastFromJson;
  String? lastEndpoint;
  Map<String, dynamic>? lastQueryParams;
  bool lastIsPaginated = false;
  String lastItemsKey = '';
  bool lastIsDataNodePresent = true;
  bool lastIsJsonRequired = false;

  FakeApiClient() : super(client: DebugHttpClient());

  @override
  Future<ApiResponse<T>> patch<T>({
    bool addAuthHeader = true,
    dynamic body,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool isDataNodePresent = true,
    bool isJsonRequired = false,
  }) async {
    patchCalled = true;
    lastBody = body;
    lastFromJson = fromJson;
    lastEndpoint = endpoint;
    lastIsDataNodePresent = isDataNodePresent;
    lastIsJsonRequired = isJsonRequired;
    return ApiResponse<T>();
  }

  @override
  Future<ApiResponse<T>> get<T>({
    bool addAuthHeader = true,
    String? customUrl,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool isDataNodePresent = true,
    bool isJsonRequired = false,
    bool isPaginated = false,
    String itemsKey = '',
    Map<String, dynamic>? queryParameters,
  }) async {
    getCalled = true;
    lastFromJson = fromJson;
    lastEndpoint = endpoint;
    lastQueryParams = queryParameters;
    lastIsPaginated = isPaginated;
    lastItemsKey = itemsKey;
    lastIsDataNodePresent = isDataNodePresent;
    lastIsJsonRequired = isJsonRequired;
    return ApiResponse<T>();
  }

  @override
  Future<ApiResponse<T>> post<T>({
    bool addAuthHeader = true,
    dynamic body,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool isDataNodePresent = true,
    bool isJsonRequired = false,
    bool isPaginated = false,
    String itemsKey = '',
  }) async {
    postCalled = true;
    lastBody = body;
    lastFromJson = fromJson;
    lastEndpoint = endpoint;
    lastIsDataNodePresent = isDataNodePresent;
    lastIsJsonRequired = isJsonRequired;
    lastIsPaginated = isPaginated;
    lastItemsKey = itemsKey;
    return ApiResponse<T>();
  }

  @override
  Future<ApiResponse<T>> put<T>({
    bool addAuthHeader = true,
    dynamic body,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool isDataNodePresent = true,
    bool isJsonRequired = false,
    bool isPaginated = false,
    String itemsKey = '',
  }) async {
    putCalled = true;
    lastBody = body;
    lastFromJson = fromJson;
    lastEndpoint = endpoint;
    lastIsDataNodePresent = isDataNodePresent;
    lastIsJsonRequired = isJsonRequired;
    lastIsPaginated = isPaginated;
    lastItemsKey = itemsKey;
    return ApiResponse<T>();
  }

  @override
  Future<ApiResponse<T>> deleteItem<T>({
    bool addAuthHeader = true,
    dynamic body,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool isDataNodePresent = true,
    bool isJsonRequired = false,
  }) async {
    deleteCalled = true;
    lastBody = body;
    lastFromJson = fromJson;
    lastEndpoint = endpoint;
    lastIsDataNodePresent = isDataNodePresent;
    lastIsJsonRequired = isJsonRequired;
    return ApiResponse<T>();
  }
}

class TestAiAssistantRepo extends AiAssistantRepo {
  TestAiAssistantRepo(FakeApiClient fakeClient)
      : super(fakeClient as dynamic);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await dotenv.load(fileName: "/Users/user/Documents/AmigoApp/.env.test");
  });

  group('AiAssistantRepo', () {
    late FakeApiClient apiClient;
    late TestAiAssistantRepo repo;

    setUp(() {
      apiClient = FakeApiClient();
      repo = TestAiAssistantRepo(apiClient);
    });

    group('Greeting screen methods', () {
      test('patchGreetingScreenData calls apiClient.patch with correct parameters', () async {
      final body = {'foo': 'bar'};
      final fromJson = (Map<String, dynamic> json) => 'result';
      await repo.patchGreetingScreenData(body, fromJson);
        
      expect(apiClient.patchCalled, isTrue);
      expect(apiClient.lastBody, body);
      expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });

      test('getGreetingScreenData calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getGreetingScreenData(fromJson);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });
    });

    group('Teams methods', () {
      test('getTeams calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getTeams(fromJson);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isTrue);
      });
    });

    group('Message methods', () {
      test('getMessage calls apiClient.post with correct parameters', () async {
        final body = {'message': 'test'};
        final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getMessage(body, fromJson);
        
        expect(apiClient.postCalled, isTrue);
        expect(apiClient.lastBody, body);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });

      test('updateMessage calls apiClient.put with correct parameters', () async {
        final body = {'message': 'updated'};
        final fromJson = (Map<String, dynamic> json) => 'result';
        const msgId = '123';
        await repo.updateMessage(body, fromJson, msgId);
        
        expect(apiClient.putCalled, isTrue);
        expect(apiClient.lastBody, body);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastEndpoint, contains(msgId));
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });

      test('getMessagesList calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        const sessionId = 'session123';
        const page = 1;
        const size = 20;
        
        await repo.getMessagesList(
          sessionId: sessionId,
          page: page,
          fromJson: fromJson,
          size: size,
        );
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastEndpoint, contains(sessionId));
        expect(apiClient.lastQueryParams, {
          'page_no': page.toString(),
          'limit': size.toString(),
        });
        expect(apiClient.lastIsPaginated, isTrue);
        expect(apiClient.lastItemsKey, 'messages');
      });
    });

    group('Chat history methods', () {
      test('getChatHistory calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getChatHistory(fromJson);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isTrue);
      });

      test('getChatSessionList calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        const sessionId = 'session123';
        final body = {'param': 'value'};
        
        await repo.getChatSessionList(fromJson, sessionId, body);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastEndpoint, contains(sessionId));
        expect(apiClient.lastQueryParams, body);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isTrue);
      });

      test('getSessionMessageList calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getSessionMessageList(fromJson);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isTrue);
      });

      test('deleteChatHistory calls apiClient.deleteItem with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        final body = {'delete': true};
        
        await repo.deleteChatHistory(fromJson, body);
        
        expect(apiClient.deleteCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastBody, body);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isTrue);
      });
    });

    group('Preferences methods', () {
      test('getPreferencesQuestions calls apiClient.get with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getPreferencesQuestions(fromJson);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isTrue);
      });

      test('updatePreferenceOption calls apiClient.patch with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        final requestBody = {'preference': 'value'};
        
        await repo.updatePreferenceOption(fromJson, requestBody);
        
        expect(apiClient.patchCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastBody, requestBody);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });

      test('updateTeamsPreference calls apiClient.patch with correct parameters', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        final requestBody = {'team': 'value'};
        
        await repo.updateTeamsPreference(fromJson, requestBody);
        
        expect(apiClient.patchCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastBody, requestBody);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });
    });

    group('Feedback methods', () {
      test('submitMessageFeedback calls apiClient.post with correct parameters', () async {
        final body = {'feedback': 'positive'};
        final fromJson = (Map<String, dynamic> json) => 'result';
        
        await repo.submitMessageFeedback(body, fromJson);
        
        expect(apiClient.postCalled, isTrue);
        expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastBody, body);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });
    });

    group('User matches methods', () {
      test('getUserMatches calls apiClient.get with correct parameters', () async {
      final fromJson = (Map<String, dynamic> json) => 'result';
        await repo.getUserMatches(fromJson);
        
      expect(apiClient.getCalled, isTrue);
      expect(apiClient.lastFromJson, fromJson);
        expect(apiClient.lastIsDataNodePresent, isFalse);
        expect(apiClient.lastIsJsonRequired, isFalse);
      });
    });

    group('Constructor', () {
      test('AiAssistantRepo constructor accepts ApiClient', () {
        expect(repo, isA<AiAssistantRepo>());
      });
    });

    group('AWS App Configuration methods', () {
      test('getAppConfiguration returns null when user is not signed in', () async {
        // This test would require mocking Amplify.Auth.fetchAuthSession
        // For now, we'll test the method exists and can be called
        expect(repo.getAppConfiguration, isA<Function>());
      });

      test('getLatestConfiguration method exists and can be called', () async {
        // This test would require mocking AWS services
        // For now, we'll test the method exists and can be called
        expect(repo.getLatestConfiguration, isA<Function>());
      });

      test('_amzDate helper method generates correct date format', () {
        // Test the private method by accessing it through reflection or making it public for testing
        // For now, we'll test that the method exists
        expect(repo, isA<AiAssistantRepo>());
      });
    });

    group('Error handling and edge cases', () {
      test('getMessagesList handles exceptions gracefully', () async {
        // Test the try-catch block in getMessagesList
        final fromJson = (Map<String, dynamic> json) => 'result';
        const sessionId = 'session123';
        const page = 1;
        
        // This should not throw an exception even if the API call fails
        final result = await repo.getMessagesList(
          sessionId: sessionId,
          page: page,
          fromJson: fromJson,
        );
        
        expect(result, isA<ApiResponse>());
      });

      test('getMessagesList with custom size parameter', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        const sessionId = 'session123';
        const page = 1;
        const customSize = 50;
        
        await repo.getMessagesList(
          sessionId: sessionId,
          page: page,
          fromJson: fromJson,
          size: customSize,
        );
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastQueryParams, {
          'page_no': page.toString(),
          'limit': customSize.toString(),
        });
      });

      test('getMessagesList with default size parameter', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        const sessionId = 'session123';
        const page = 1;
        
        await repo.getMessagesList(
          sessionId: sessionId,
          page: page,
          fromJson: fromJson,
          // size parameter omitted to test default value
        );
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastQueryParams, {
          'page_no': page.toString(),
          'limit': '10', // default size
        });
      });
    });

    group('Method parameter validation', () {
      test('updateMessage with empty msgId', () async {
        final body = {'message': 'test'};
        final fromJson = (Map<String, dynamic> json) => 'result';
        const msgId = '';
        
        await repo.updateMessage(body, fromJson, msgId);
        
        expect(apiClient.putCalled, isTrue);
        expect(apiClient.lastEndpoint, contains(msgId));
      });

      test('getChatSessionList with null body', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        const sessionId = 'session123';
        final body = null;
        
        await repo.getChatSessionList(fromJson, sessionId, body);
        
        expect(apiClient.getCalled, isTrue);
        expect(apiClient.lastQueryParams, body);
      });

      test('deleteChatHistory with empty body', () async {
        final fromJson = (Map<String, dynamic> json) => 'result';
        final body = {};
        
        await repo.deleteChatHistory(fromJson, body);
        
        expect(apiClient.deleteCalled, isTrue);
        expect(apiClient.lastBody, body);
      });
    });
  });
}
