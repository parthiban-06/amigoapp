import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../remote/api_client.dart';
import '../../../remote/api_response.dart';
import '../../../utils/app_const.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';

class AiAssistantRepo {
  final ApiClient apiClient;

  AiAssistantRepo(this.apiClient);

  Future<ApiResponse<T>> getTeams<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
      endpoint: AppConst.getTeams,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> getMessage<T>(
      dynamic body, T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.post(
        endpoint: AppConst.GET_MESSAGE,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> updateMessage<T>(dynamic body,
      T Function(Map<String, dynamic> json) fromJson, String msgId) async {
    return await apiClient.put(
        endpoint: "${AppConst.GET_MESSAGE}/$msgId",
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  // Added method to get messages list with pagination
  Future<ApiResponse<T>> getMessagesList<T>({
    required String sessionId,
    required int page,
    required T Function(Map<String, dynamic>) fromJson,
    int size = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page_no': page.toString(),
        'limit': size.toString(),
      };

      return await apiClient.get<T>(
          endpoint: '/ai-service/sessions/$sessionId/messages',
          queryParameters: queryParams,
          fromJson: fromJson,
          itemsKey: "messages",
          isPaginated: true);
    } catch (e) {
      Utils.logPrint("getMessagesList error: $e");
      return ApiResponse<T>();
    }
  }

  Future<ApiResponse<T>> getChatHistory<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.GET_SESSION,
        // body: body,
        isJsonRequired: true,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getChatSessionList<T>(
      T Function(Map<String, dynamic> json) fromJson,
      String sessionId,
      dynamic body) async {
    return await apiClient.get(
        endpoint: "/ai-service/sessions/${sessionId}/messages/",
        queryParameters: body,
        isJsonRequired: true,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getSessionMessageList<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.GET_SESSION,
        // body: body,
        isJsonRequired: true,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> deleteChatHistory<T>(
    T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
  ) async {
    return await apiClient.deleteItem(
      endpoint: AppConst.GET_SESSION,
      body: body,
      isDataNodePresent: false,
      isJsonRequired: true,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> getPreferencesQuestions<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
      endpoint: AppConst.getPreferencesQuestions,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> updatePreferenceOption<T>(
    T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> requestBody,
  ) async {
    return await apiClient.patch(
        endpoint: AppConst.updatePreferenceOption,
        body: requestBody,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> updateTeamsPreference<T>(
    T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> requestBody,
  ) async {
    return await apiClient.patch(
        endpoint: AppConst.updateTeamsPreference,
        body: requestBody,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> submitMessageFeedback<T>(
      dynamic body, T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.post(
        endpoint: AppConst.submitMessageFeedback,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getGreetingScreenData<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.greetingScreenData,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> patchGreetingScreenData<T>(
      dynamic body, T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.patch(
        endpoint: AppConst.changeGreetingScreenData,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getUserMatches<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
      endpoint: AppConst.getUserMatches,
      fromJson: fromJson,
      isDataNodePresent: false,
    );
  }

  // Function to get AWS App Configurations
  Future<Map<String, dynamic>?> getAppConfiguration() async {
    final region = dotenv.env['AWS_USER_REGION']!;

    final applicationId = dotenv.env['AWS_APP_CONFIG_APPLICATION_ID']!;
    final environmentId = dotenv.env['AWS_APP_CONFIG_ENVIRONMENT_ID']!;
    final configurationId = dotenv.env['AWS_APP_CONFIG_CONFIGURATION_ID']!;

    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (!session.isSignedIn) {
        Utils.logPrint("User is not signed in");
        return null;
      }

      final token = (session as CognitoAuthSession);

      // Get AWS credentials (accessKey, secretKey, and sessionToken)
      final credentials = token.credentialsResult.value;
      final sessionToken = credentials.sessionToken;

      Utils.logPrint("Session: $sessionToken");

      // Create the signer with the credentials
      final signer = AWSSigV4Signer(
        credentialsProvider: AWSCredentialsProvider(credentials),
      );

      // Define the request
      final startSessionRequest = AWSHttpRequest(
        method: AWSHttpMethod.post,
        uri: Uri.https(
            'appconfigdata.$region.amazonaws.com', '/configurationsessions'),
        headers: {
          AWSHeaders.contentType: 'application/json',
          'X-Amz-Date': DateTime.now()
              .toUtc()
              .toIso8601String()
              .replaceAll(":", "")
              .replaceAll("-", ""),
          'X-Amz-Security-Token': sessionToken ?? "",
        },
        body: json.encode({
          "ApplicationIdentifier": applicationId,
          "ConfigurationProfileIdentifier": configurationId,
          "EnvironmentIdentifier": environmentId
        }).codeUnits,
      );

      // Prepare the credential scope for signing
      final scope = AWSCredentialScope(
        region: region,
        service: AWSService.appConfig,
      );

      // Sign the start session request
      final signedStartRequest =
          await signer.sign(startSessionRequest, credentialScope: scope);

      // Send the signed start session request
      final startResp = signedStartRequest.send();
      final startRespBody = await startResp.response;
      // Await the decodeBody() result before passing it to jsonDecode.
      final startBodyString = await startRespBody.decodeBody();
      final startRespJson = jsonDecode(startBodyString);
      Utils.logPrint('Start Session Response: $startRespJson');

      // Extract the initial configuration token from the response
      final initialConfigToken = startRespJson['InitialConfigurationToken'];
      if (initialConfigToken == null) {
        throw Exception("No initial configuration token received.");
      }

      final configuration = await getLatestConfiguration(
        region: region,
        signer: signer,
        scope: scope,
        sessionToken: sessionToken ?? "",
        // from your auth session
        configurationToken: startRespJson[
            'InitialConfigurationToken'], // token from StartConfigurationSession
      );

      Preferences.setMapData(Preferences.keyAppConfig, configuration);

      return configuration;
    } catch (e) {
      Utils.logPrint('Error: $e');
      return null;
    }
  }

  /// Consumes the GetLatestConfiguration API.
  ///
  /// [region]: The AWS region (e.g., 'us-east-1').
  /// [signer]: An instance of AWSSigV4Signer configured with your credentials.
  /// [scope]: The AWSCredentialScope with the correct region and service.
  /// [sessionToken]: Your AWS session token (if using temporary credentials).
  /// [configurationToken]: The token received from StartConfigurationSession.
  Future<Map<String, dynamic>> getLatestConfiguration({
    required String region,
    required AWSSigV4Signer signer,
    required AWSCredentialScope scope,
    required String sessionToken,
    required String configurationToken,
  }) async {
    // Build the URI with the required query parameter.
    final uri = Uri.https(
      'appconfigdata.$region.amazonaws.com',
      '/configuration',
      {
        'configuration_token': configurationToken,
      },
    );

    // Build the AWSHttpRequest.
    final awsRequest = AWSHttpRequest(
      method: AWSHttpMethod.get,
      uri: uri,
      headers: {
        AWSHeaders.contentType: 'application/json',
        'X-Amz-Date': _amzDate(),
        'X-Amz-Security-Token': sessionToken,
      },
    );

    // Sign the request.
    final signedRequest = await signer.sign(awsRequest, credentialScope: scope);

    // Send the request.
    final signedResponse = signedRequest.send();
    // Await the Future in the response property to get the actual response.
    final awsResponse = await signedResponse.response;
    final responseBody = await awsResponse.decodeBody();

    // Check for success.
    if (awsResponse.statusCode == 200) {
      // The response headers also include:
      // - Next-Poll-Configuration-Token
      // - Next-Poll-Interval-In-Seconds
      // - Version-Label (if applicable)
      //
      // You can access these via awsResponse.headers if needed.
      Utils.logPrint(
          'Next-Poll-Configuration-Token: ${awsResponse.headers['next-poll-configuration-token']}');
      Utils.logPrint(
          'Next-Poll-Interval-In-Seconds: ${awsResponse.headers['next-poll-interval-in-seconds']}');
      Utils.logPrint('Version-Label: ${awsResponse.headers['version-label']}');
      Utils.logPrint('RESPONSE APP CONFIG>>$responseBody');
      // The body contains your configuration (which might be empty if there is no update).
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to fetch configuration. Status: ${awsResponse.statusCode}\nBody: $responseBody');
    }
  }

  /// Helper function to generate X-Amz-Date header value in the proper format.
  String _amzDate() {
    final now = DateTime.now().toUtc();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return "$year$month${day}T$hour$minute${second}Z";
  }
}
