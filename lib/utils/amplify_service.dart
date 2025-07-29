import 'dart:convert';

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../amplifyconfiguration.dart';
import '../analytics/firebase_analytics_service.dart';
import '../remote/api_response.dart';

class AmplifyService {
  static const AMPLIFY_SUCCESS = 200;
  static const AMPLIFY_USER_SIGNUP_ALREADY_EXIST = 400;
  static const AMPLIFY_ERROR = 500;
  static const AMPLIFY_USER_NOT_EXIST = 502;

  static final AmplifyService _instance = AmplifyService._internal();

  factory AmplifyService() => _instance;

  AmplifyService._internal();

  AuthUser? _currentUser;
  Map<String, dynamic>? _userDetails;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  Map<String, dynamic> get userDetails => _userDetails ?? {};

  AuthUser? get currentUser => _currentUser;

  String? authToken;
  String? userNameInitial;

  Future<void> configureAmplify() async {
    try {
      final analytics = AmplifyAnalyticsPinpoint();
      if (!kIsWeb) {
        await Amplify.addPlugins([
          AmplifyAuthCognito(),
          analytics,
        ]);
      } else {
        await Amplify.addPlugins([
          AmplifyAuthCognito(),
          analytics,
        ]);
      }

      await Amplify.configure(amplifyconfig);

      Utils.logPrint('Successfully configured');
    } catch (e) {
      Utils.logPrint('Error configuring Amplify: $e');
    }
  }

  Future<bool> getCurrentSession() async {
    try {
      // Try to get the current session
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: false),
      );

      if (session.isSignedIn) {
        final tokens = (session as CognitoAuthSession);
        authToken = tokens.userPoolTokensResult.value.accessToken.raw;
        Utils.logPrint("AuthToken $authToken");
        Utils.logPrint(
            "AccessToken --${tokens.userPoolTokensResult.value.accessToken}");
      } else {
        return await refreshTokens();
      }

      return true;
    } on AuthException catch (e) {
      if (e.message.contains('expired')) {
        // Token is expired, force refresh
        return await refreshTokens();
      }
      // Other auth error
      // rethrow;
      return false;
    }
  }

  // Future<bool> refreshAuthTo

  Future<bool> refreshTokens() async {
    try {
      // Force refresh the tokens
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(
          forceRefresh: true,
        ),
      );
      if (session.isSignedIn) {
        final tokens = (session as CognitoAuthSession);
        authToken = tokens.userPoolTokensResult.value.accessToken.raw;
        Utils.logPrint("refreshTokens AuthToken $authToken");
        Utils.logPrint(
            "refreshTokens AccessToken --${tokens.userPoolTokensResult.value.accessToken}");
        return true;
      } else {
        Utils.logPrint("no valid refresh token");
        // await Amplify.Auth.signOut();
        // AppRouter.router.pushRoute(
        //   AppRoutes.registeredEmail,
        // );
        // await Amplify.Auth.signOut();
        return false;
      }
    } catch (e) {
      // Failed to refresh, user may need to sign in again
      return false;

      // throw Exception('Session expired. Please sign in again.');
    }
  }

  Future<ApiResponse> signInUser(
      {BuildContext? context,
      String? username,
      String? password,
      String? userLanguage}) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    try {
      final signInResponse = await Amplify.Auth.signIn(
        username: username ?? "",
        password: password ?? "",
        options: SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
            clientMetadata: {
              AppConst.PREFERRED_LANGUAGE:
                  (userLanguage == null || userLanguage.isEmpty)
                      ? "en"
                      : userLanguage,
            },
          ),
        ),
      );
      Utils.logPrint('signInResponse: $signInResponse');
      return ApiResponse<SignInResult>(
        data: signInResponse,
        statusCode: AMPLIFY_SUCCESS,
      );
    } on UserNotFoundException {
      Utils.logPrint("❌ Error: User does not exist.");
      // snackBar(context!, er["message"]);
      return ApiResponse<SignInResult>(
        error: capturedContext != null && capturedContext.mounted
            ? S.of(capturedContext).user_does_not_exist
            : "User does not exist",
        statusCode: AMPLIFY_USER_NOT_EXIST,
      );
    } on UserNotConfirmedException {
      Utils.logPrint("⚠️ Error: User is not confirmed. Verify email or phone.");
      return ApiResponse<SignInResult>(
        error: capturedContext != null && capturedContext.mounted
            ? S.of(capturedContext).account_not_verify
            : "Account not verified",
        statusCode: AMPLIFY_ERROR,
      );
    } on LimitExceededException {
      Utils.logPrint("⚠️ Error: Too many attempts. Try again later.");
      return ApiResponse<SignInResult>(
        error: capturedContext != null && capturedContext.mounted
            ? S.of(capturedContext).too_many_attempts
            : "Too many attempts",
        statusCode: AMPLIFY_ERROR,
      );
    } catch (e) {
      Utils.logPrint('Error signing in: $e');
      dynamic er = jsonDecode(jsonEncode(e));
      if (er["message"].toString().toLowerCase() ==
          "incorrect username or password.") {
        return ApiResponse<SignInResult>(
          error: capturedContext != null && capturedContext.mounted
              ? S.of(capturedContext).incorrect_username
              : "Incorrect username or password",
          statusCode: AMPLIFY_ERROR,
        );
      } else if (er["message"].toString().toLowerCase() ==
          "user is disabled.") {
        return ApiResponse<SignInResult>(
          error: capturedContext != null && capturedContext.mounted
              ? S.of(capturedContext).user_is_disable
              : "User is disabled",
          statusCode: AMPLIFY_ERROR,
        );
      } else if (er["message"].toString().toLowerCase() ==
          "password reset required for the user") {
        return ApiResponse<SignInResult>(
          error: capturedContext != null && capturedContext.mounted
              ? S.of(capturedContext).password_reset_required
              : "Password reset required",
          statusCode: AMPLIFY_ERROR,
        );
      } else {
        return ApiResponse<SignInResult>(
          error: er["message"],
          statusCode: AMPLIFY_ERROR,
        );
      }
    }
  }

  Future<AuthSession?> checkIfSignedIn(BuildContext context) async {
    try {
      // Fetch the current authentication session
      AuthSession session = await Amplify.Auth.fetchAuthSession();
      // Check if the user is signed in
      Utils.logPrint("checkIfSignedIn: ${session.isSignedIn}");
      return session;
    } catch (e) {
      Utils.logPrint("Error checking sign-in status: $e");
      return null;
    }
  }

  Future<dynamic> forgotPasswordCode(
      {required BuildContext context,
      String? username,
      String? password,
      String? code}) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    try {
      return await Amplify.Auth.confirmResetPassword(
        username: username ?? "",
        newPassword: password ?? "",
        confirmationCode: code ?? "",
      );
    } on AuthException catch (e) {
      if (e.message.contains("code")) {
        if (capturedContext.mounted) {
          return S.of(capturedContext).invalid_code;
        }
        return "Invalid code";
      } else {
        return e.message;
      }
    }
  }

  Future<ApiResponse> signUpUser(
    BuildContext? context,
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? userLanguage,
  ) async {
    try {
      final userData = await Amplify.Auth.signUp(
          username: username ?? "",
          password: password ?? "",
          options: SignUpOptions(userAttributes: <AuthUserAttributeKey, String>{
            AuthUserAttributeKey.familyName: lastName ?? "",
            AuthUserAttributeKey.givenName: firstName ?? "",
            AuthUserAttributeKey.picture: "default",
            AuthUserAttributeKey.updatedAt:
                DateTime.now().millisecondsSinceEpoch.toString(),
            const CognitoUserAttributeKey.custom(AppConst.PREFERRED_LANGUAGE):
                (userLanguage == null || userLanguage.isNullOrEmpty)
                    ? "en"
                    : userLanguage,
          }));

      return ApiResponse<SignUpResult>(
        data: userData,
        statusCode: AMPLIFY_SUCCESS,
      );
    } on UsernameExistsException catch (e) {
      Utils.logPrint('Error signing in UsernameExistsException: $e');
      return ApiResponse<SignUpResult>(
        error: e.message,
        statusCode: AMPLIFY_USER_SIGNUP_ALREADY_EXIST,
      );
    } catch (e) {
      Utils.logPrint('Error signing in: $e');
      // Handle other auth-related errors
      return ApiResponse<SignUpResult>(
        error: jsonDecode(jsonEncode(e.toString())).toString(),
        statusCode: AMPLIFY_ERROR,
      );
    }
  }

  Future<ApiResponse> confirmMfaSignIn(String code) async {
    try {
      final result = await Amplify.Auth.confirmSignIn(confirmationValue: code);

      if (result.isSignedIn) {
        return ApiResponse<SignInResult>(
          data: result,
          statusCode: AMPLIFY_SUCCESS,
        );
      } else {
        return ApiResponse<SignInResult>(
          error: "",
          statusCode: AMPLIFY_ERROR,
        );
      }
    } catch (e) {
      // Handle other auth-related errors
      return ApiResponse<SignUpResult>(
        error: e.toString(),
        statusCode: AMPLIFY_ERROR,
      );
    }
  }

  Future<ApiResponse> confirmSignUpUser(
      {required BuildContext context, String? username, String? code}) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    Utils.logPrint(username);
    Utils.logPrint(code);
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username ?? "",
        confirmationCode: code ?? "",
      );
      if (result.isSignUpComplete) {
        return ApiResponse<SignUpResult>(
          data: result,
          statusCode: AMPLIFY_SUCCESS,
        );
      } else {
        return ApiResponse<SignUpResult>(
          error: "",
          statusCode: AMPLIFY_ERROR,
        );
      }
    } on CodeMismatchException {
      if (capturedContext != null && capturedContext.mounted) {
        return ApiResponse<SignUpResult>(
          error: S.of(capturedContext).invalid_code, // Handle invalid code
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignUpResult>(
        error: "Invalid code",
        statusCode: AMPLIFY_ERROR,
      );
    } on LimitExceededException {
      if (capturedContext != null && capturedContext.mounted) {
        return ApiResponse<SignUpResult>(
          error: S.of(capturedContext).limit_exceed, // Handle too many attempts
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignUpResult>(
        error: "Limit exceeded",
        statusCode: AMPLIFY_ERROR,
      );
    } on AuthException catch (e) {
      Utils.logPrint('AuthException: ${e.message}');
      if (capturedContext != null && capturedContext.mounted) {
        return ApiResponse<SignUpResult>(
          error: S.of(capturedContext).invalid_code,
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignUpResult>(
        error: "Invalid code",
        statusCode: AMPLIFY_ERROR,
      );
    } catch (e) {
      Utils.logPrint('Unknown error: $e');
      if (capturedContext != null && capturedContext.mounted) {
        return ApiResponse<SignUpResult>(
          error: S.of(capturedContext).invalid_code,
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignUpResult>(
        error: "Invalid code",
        statusCode: AMPLIFY_ERROR,
      );
    }

    // catch (e) {
    //   Utils.logPrint('Error signing in: $e');
    //   dynamic er = jsonDecode(jsonEncode(e));
    //   return ApiResponse<SignUpResult>(
    //     error: S.of(context).invalid_code,
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // }

    // blow code is for different issues

    // on UsernameExistsException catch (_) {
    //   return ApiResponse<SignUpResult>(
    //     error: "An account with this email already exists. Try signing in.",
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // } on InvalidPasswordException catch (_) {
    //   return ApiResponse<SignUpResult>(
    //     error:
    //         "Password does not meet security requirements. Please try again.",
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // } on InvalidParameterException catch (_) {
    //   return ApiResponse<SignUpResult>(
    //     error:
    //         "Invalid sign-up details provided. Check your email format and other inputs.",
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // } on TooManyRequestsException catch (_) {
    //   return ApiResponse<SignUpResult>(
    //     error: "Too many sign-up attempts. Please wait and try again later.",
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // } on AuthException catch (e) {
    //   print("sss");
    //   return ApiResponse<SignUpResult>(
    //     error: e.message,
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // } catch (e) {
    //   return ApiResponse<SignUpResult>(
    //     error: "An unexpected error occurred. Please try again later.",
    //     statusCode: AMPLIFY_ERROR,
    //   );
    // }
    // } catch (e) {
    //   Utils.logPrint('Error signing in: $e');
    //   dynamic er = jsonDecode(jsonEncode(e));
    //   return ApiResponse<SignUpResult>(
    //     error: S.of(context).invalid_code,
    //     statusCode: AMPLIFY_ERROR,
    //   );
    //   // return null;
    // }
  }

  Future<ApiResponse> resendSignUpCode(
      {required BuildContext context, String? username}) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    try {
      final response =
          await Amplify.Auth.resendSignUpCode(username: username ?? "");

      return ApiResponse<ResendSignUpCodeResult>(
        data: response,
        statusCode: AMPLIFY_SUCCESS,
      );
    } catch (e) {
      Utils.logPrint('Error signing in: $e');
      dynamic er = jsonDecode(jsonEncode(e));
      return ApiResponse<ResendSignUpCodeResult>(
        error: er["message"],
        statusCode: AMPLIFY_ERROR,
      );
    }
  }

  Future<void> customSignInUser({String? username, String? password}) async {
    try {
      await Amplify.Auth.sendUserAttributeVerificationCode(
          userAttributeKey: AuthUserAttributeKey.email);
    } catch (e) {
      Utils.logPrint('Error signing in: $e');
    }
  }

  Future<SignOutResult?> signOutUser() async {
    try {
      final response = await Amplify.Auth.signOut();

      _currentUser = null;
      _userDetails?.clear();
      _userDetails = null;
      authToken = null;
      FirebaseAnalyticsService.userAnalyticsId = "";

      var languageCode =
          await Preferences.getString(Preferences.keyLanguageCode);
      bool is24hrs = await Preferences.getString(Preferences.KeyIs24Time);

      var keyAnalyticsTracking =
          await Preferences.getBool(Preferences.keyAnalyticsTracking);
      await Preferences.clear();
      await Preferences.setString(Preferences.keyLanguageCode, languageCode);
      await Preferences.setBool(Preferences.KeyIs24Time, is24hrs);
      await Preferences.setBool(
          Preferences.keyAnalyticsTracking, keyAnalyticsTracking);
      await FirebaseAnalyticsService.clearUserOnLogout();
      return response;
    } catch (e) {
      Utils.logPrint('Error signing in: $e');
      return null;
    }
  }

  Future<dynamic> initiateForgotPassword(
      {required BuildContext context,
      String? username,
      String? userLanguage}) async {
    try {
      return await Amplify.Auth.resetPassword(
        username: username ?? "",
        options: ResetPasswordOptions(
          pluginOptions: CognitoResetPasswordPluginOptions(
            clientMetadata: {
              AppConst.PREFERRED_LANGUAGE:
                  (userLanguage == null || userLanguage.isEmpty)
                      ? "en"
                      : userLanguage,
            },
          ),
        ),
      );
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<ApiResponse?> confirmSignIn(
      {required BuildContext? context, String? code}) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    try {
      final confirmPass = await Amplify.Auth.confirmSignIn(
        confirmationValue: code ?? "",
      );

      if (confirmPass.isSignedIn) {
        return ApiResponse<SignInResult>(
          data: confirmPass,
          statusCode: AMPLIFY_SUCCESS,
        );
      } else {
        return ApiResponse<SignInResult>(
          error: "",
          statusCode: AMPLIFY_ERROR,
        );
      }
    } on CodeMismatchException catch (_) {
      Utils.logPrint('CodeMismatchException: ${_.message}');

      if (capturedContext != null && capturedContext!.mounted) {
        return ApiResponse<SignInResult>(
          error: S.of(capturedContext!).invalid_code,
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignInResult>(
        error: "Invalid code",
        statusCode: AMPLIFY_ERROR,
      );
    } on LimitExceededException catch (_) {
      Utils.logPrint('CodeMismatchException: ${_.message}');
      if (capturedContext != null && capturedContext!.mounted) {
        return ApiResponse<SignInResult>(
          error: S
              .of(capturedContext!)
              .limit_exceed, // Handle too many failed attempts
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignInResult>(
        error: "Limit exceeded",
        statusCode: AMPLIFY_ERROR,
      );
    } on AuthException catch (e) {
      Utils.logPrint('AuthException asd: ${e}');
      if (e.message.contains("temporarily locked")) {
        if (capturedContext != null && capturedContext!.mounted) {
          return ApiResponse<SignInResult>(
            error: S.of(capturedContext!).too_many_attempts,
            statusCode: AMPLIFY_ERROR,
          );
        }
        return ApiResponse<SignInResult>(
          error: "Too many attempts",
          statusCode: AMPLIFY_ERROR,
        );
      }
      if (capturedContext != null && capturedContext!.mounted) {
        return ApiResponse<SignInResult>(
          error: S.of(capturedContext!).otp_expired,
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignInResult>(
        error: "OTP expired",
        statusCode: AMPLIFY_ERROR,
      );
    } catch (e) {
      Utils.logPrint('Unknown error: $e');
      if (capturedContext != null && capturedContext!.mounted) {
        return ApiResponse<SignInResult>(
          error: S.of(capturedContext!).invalid_code,
          statusCode: AMPLIFY_ERROR,
        );
      }
      return ApiResponse<SignInResult>(
        error: "Invalid code",
        statusCode: AMPLIFY_ERROR,
      );
    }
  }

  // Future<ApiResponse?> confirmSignIn({String? code}) async {
  //   try {
  //     final confirmPass = await Amplify.Auth.confirmSignIn(
  //       confirmationValue: code ?? "",
  //     );
  //
  //     if (confirmPass.isSignedIn) {
  //       return ApiResponse<SignInResult>(
  //         data: confirmPass,
  //         statusCode: AMPLIFY_SUCCESS,
  //       );
  //     } else {
  //       return ApiResponse<SignInResult>(
  //         error: "",
  //         statusCode: AMPLIFY_ERROR,
  //       );
  //     }
  //   } catch (e) {
  //     dynamic er = jsonDecode(jsonEncode(e));
  //     return ApiResponse<SignInResult>(
  //       error: er["message"],
  //       statusCode: AMPLIFY_ERROR,
  //     );
  //   }
  //
  //   /*
  //     try {
  //     final signInResponse = await Amplify.Auth.signIn(
  //       username: username ?? "",
  //       password: password ?? "",
  //     );
  //     Utils.logPrint('signInResponse: $signInResponse');
  //     return ApiResponse<SignInResult>(
  //       data: signInResponse,
  //       statusCode: AMPLIFY_SUCCESS,
  //     );
  //   } catch (e) {
  //     Utils.logPrint('Error signing in: $e');
  //     dynamic er = jsonDecode(jsonEncode(e));
  //     snackBar(context!, er["message"]);
  //     return ApiResponse<SignInResult>(
  //       error: jsonDecode(jsonEncode(e.toString())).toString(),
  //       statusCode: AMPLIFY_ERROR,
  //     );
  //   }
  //    */
  // }

  Future<void> respondToMfaChallenge(
      String email, String mfaCode, String session) async {
    final url = 'https://cognito-idp.ap-south-1.amazonaws.com/';

    final body = jsonEncode({
      "ChallengeName": "SMS_MFA",
      // or "SOFTWARE_TOKEN_MFA" depending on the setup
      "ClientId": "--clientId--",
      "ChallengeResponses": {
        "USERNAME": email,
        "SMS_MFA_CODE": mfaCode, // or "SOFTWARE_TOKEN_MFA_CODE" for TOTP
      },
      "Session": session,
      // You get this from the InitiateAuth response
    });
  }

  Future<void> setupMFA(bool enableMFA) async {
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);

      await cognitoPlugin.updateMfaPreference(
        email: enableMFA
            ? MfaPreference.enabled
            : MfaPreference.disabled, // or .preferred
      );
      Utils.logPrint('MFA setup completed');
    } on AuthException catch (e) {
      Utils.logPrint('Setup MFA error: ${e.message}');
      // rethrow;
    }
  }

  Future<bool> checkMFA() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();

      Utils.logPrint(
          "attr.userAttributeKey.key isEmailMfaEnabled ${attributes}");
      final mfaSetting = attributes.firstWhere(
        (attr) => attr.userAttributeKey.key == 'preferredMfaSetting',
        // orElse: () => ,
      );

      if (mfaSetting.value == 'EMAIL') {
        Utils.logPrint('MFA via Email is enabled.');
      } else {
        Utils.logPrint('MFA via Email is not enabled.');
      }

      return (mfaSetting.value == 'EMAIL');
    } catch (e) {
      Utils.logPrint('Error fetching user attributes: $e');
      return false;
    }
  }

  // Setup MFA

  // Get current user's details
  Future<void> getCurrentUser() async {
    try {
      _currentUser = await Amplify.Auth.getCurrentUser();
      // final attributes = await Amplify.Auth.fetchUserAttributes();

      await _getUserAccessToken();

      // // Add all user attributes to the map
      // for (final attribute in attributes) {
      //   _userDetails![attribute.userAttributeKey.toString()] = attribute.value;
      // }

      // Utils.logPrint(_userDetails);
    } on UserNotFoundException catch (e) {
      Utils.logoutUser();
    } on AuthException catch (e) {
      Utils.logPrint('AuthException exception: $e');
    } catch (e) {
      Utils.logPrint('getCurrentUser exception: $e');
    }
  }

  Future<void> _getUserAccessToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      // getCurrentSession
      if (session.isSignedIn) {
        // Access the JWT token
        final tokens = (session as CognitoAuthSession);
        authToken = tokens.userPoolTokensResult.value.accessToken.raw;
        Utils.logPrint("AuthToken $authToken");
        Utils.logPrint(
            "AccessToken --${tokens.userPoolTokensResult.value.accessToken}");
      } else {
        await getCurrentSession();
      }

      // return authToken;
    } on UserNotFoundException catch (e) {
      Utils.logoutUser();
    } catch (e) {
      // await getCurrentSession();
      Utils.logPrint('_getUserAccessToken exception: $e');
      // return null;
    }
  }

  // Get specific user attribute
  Future<String?> getUserAttribute(AuthUserAttributeKey attributeKey) async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final attributeOpt = attributes.where(
        (element) => element.userAttributeKey == attributeKey,
      );

      if (attributeOpt.isNotEmpty) {
        return attributeOpt.first.value;
      }
      return null;
    } on AuthException catch (e) {
      // throw Exception('Failed to get user attribute: ${e.message}');
    }
    return "";
  }

  // Check if user is signed in
  Future<bool> isUserSignedIn() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      return result.isSignedIn;
    } catch (e) {
      return false;
    }
  }

  Future<({bool isValid, String? errorMessage})> verifyPasswordWithCognito({
    required String username,
    required String password,
  }) async {
    try {
      // Check if user is signed in
      final session = await Amplify.Auth.fetchAuthSession();
      if (!session.isSignedIn) {
        return (isValid: false, errorMessage: "User is not signed in.");
      }

      final token = session as CognitoAuthSession;
      final credentials = token.credentialsResult.value;
      final sessionToken = credentials.sessionToken;
      final region = dotenv.env['AWS_USER_REGION']!;
      final clientId = dotenv.env['AWS_USER_CLIENT_ID'];

      if (clientId == null || clientId.isEmpty) {
        return (isValid: false, errorMessage: "ClientId is missing from .env");
      }

      final requestBody = jsonEncode({
        "AuthFlow": "USER_PASSWORD_AUTH",
        "ClientId": clientId,
        "AuthParameters": {
          "USERNAME": username,
          "PASSWORD": password,
        }
      });

      final uri = Uri.https('cognito-idp.$region.amazonaws.com', '/');

      final request = AWSHttpRequest(
        method: AWSHttpMethod.post,
        uri: uri,
        headers: {
          AWSHeaders.contentType: 'application/x-amz-json-1.1',
          'X-Amz-Target': 'AWSCognitoIdentityProviderService.InitiateAuth',
          'X-Amz-Security-Token': sessionToken ?? "",
        },
        body: utf8.encode(requestBody),
      );

      final signer = AWSSigV4Signer(
        credentialsProvider: AWSCredentialsProvider(credentials),
      );

      final scope = AWSCredentialScope(
        region: region,
        service: AWSService.cognitoIdentityProvider,
      );

      final signedRequest = await signer.sign(request, credentialScope: scope);

      final response = signedRequest.send();
      final body = await (await response.response).decodeBody();
      final jsonBody = jsonDecode(body);

      if (jsonBody.containsKey("AuthenticationResult")) {
        return (isValid: true, errorMessage: null);
      }

      // Could be another case like MFA required etc.
      final parsedMessage =
          jsonBody['message'] == 'Incorrect username or password.'
              ? Utils.getErrorMessageFromString(AppConst.invalidPassword)
              : jsonBody['message'] ??
                  Utils.getErrorMessageFromString(
                      AppConst.unknownAuthenticationError);
      return (isValid: false, errorMessage: parsedMessage.toString());
    } on AWSHttpException catch (e) {
      final errorMessage = e.underlyingException?.toString() ?? e.toString();

      if (errorMessage.contains("NotAuthorizedException")) {
        return (
          isValid: false,
          errorMessage:
              Utils.getErrorMessageFromString(AppConst.invalidPassword)
        );
      } else if (errorMessage.contains("UserNotFoundException")) {
        return (
          isValid: false,
          errorMessage: Utils.getErrorMessageFromString(AppConst.userNotFound)
        );
      } else if (errorMessage.contains("UserNotConfirmedException")) {
        return (
          isValid: false,
          errorMessage:
              Utils.getErrorMessageFromString(AppConst.userIsNotConfirmed)
        );
      }

      return (isValid: false, errorMessage: "AWS HTTP error: $errorMessage");
    } catch (e) {
      return (isValid: false, errorMessage: "Unexpected error: $e");
    }
  }

  // Get user email
  Future<String?> getUserEmail() async {
    return getUserAttribute(AuthUserAttributeKey.email);
  }

  // Get user phone number
  Future<String?> getUserPhone() async {
    return getUserAttribute(AuthUserAttributeKey.phoneNumber);
  }

  // Get user's full name
  Future<String?> getUserName() async {
    return getUserAttribute(AuthUserAttributeKey.name);
  }

  // Get user's full name
  Future<String?> getUserIntial() async {
    userNameInitial = userNameInitial ?? await getUserGivenName();
    return (userNameInitial.isNullOrEmpty)
        ? ""
        : userNameInitial![0].toUpperCase();
  }

  // Get user's given name
  Future<String?> getUserGivenName() async {
    return getUserAttribute(AuthUserAttributeKey.givenName);
  }

  // Get user's family name
  Future<String?> getUserFamilyName() async {
    return getUserAttribute(AuthUserAttributeKey.familyName);
  }

  // Get user's preferred username
  Future<String?> getPreferredUsername() async {
    return getUserAttribute(AuthUserAttributeKey.preferredUsername);
  }

  // Get user's drawer picture
  Future<String?> getProfilePicture() async {
    return getUserAttribute(AuthUserAttributeKey.picture);
  }

  // Test method to verify Firebase messaging setup
  Future<void> testFirebaseMessaging() async {
    try {
      Utils.logPrint("🧪 Testing Firebase messaging setup...");

      // Check if Firebase is initialized
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      Utils.logPrint(
          "🧪 Notification settings: ${settings.authorizationStatus}");

      // Get FCM token
      final token = await FirebaseMessaging.instance.getToken();
      Utils.logPrint("🧪 FCM Token: $token");

      // Check if listeners are working
      Utils.logPrint("🧪 Firebase messaging test completed");

      return;
    } catch (e) {
      Utils.logPrint("❌ Firebase messaging test failed: $e");
    }
  }
}
