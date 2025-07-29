import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/utils/utils.dart';

import '../custom_widgets/snackbar.dart';
import '../remote/api_response.dart';

class AmplifyServiceWithFailover {
  static const AMPLIFY_SUCCESS = 200;
  static const AMPLIFY_USER_SIGNUP_ALREADY_EXIST = 400;
  static const AMPLIFY_ERROR = 500;

  static final AmplifyServiceWithFailover _instance =
      AmplifyServiceWithFailover._internal();

  factory AmplifyServiceWithFailover() => _instance;

  AmplifyServiceWithFailover._internal();

  late final AmplifyAuthCognito _primaryAuth;
  late final AmplifyAuthCognito _backupAuth;
  bool _isPrimaryConfigured = false;
  bool _isBackupConfigured = false;
  bool _usingBackupPool = false;

  AuthUser? _currentUser;
  Map<String, dynamic>? _userDetails;

  Map<String, dynamic> get userDetails => _userDetails ?? {};

  AuthUser? get currentUser => _currentUser;

  bool get isUsingBackupPool => _usingBackupPool;

  Future<void> configureAmplify({
    required Map<String, dynamic> primaryConfig,
    required Map<String, dynamic> backupConfig,
  }) async {
    try {
      // Configure primary auth
      _primaryAuth = AmplifyAuthCognito();
      await Amplify.addPlugin(_primaryAuth);
      await Amplify.configure(jsonEncode(primaryConfig));
      _isPrimaryConfigured = true;

      // Configure backup auth
      _backupAuth = AmplifyAuthCognito();

      // Create a new Amplify instance for backup configuration
      final backupAmplify = AmplifyClass();
      await backupAmplify.addPlugin(_backupAuth);
      await backupAmplify.configure(jsonEncode(backupConfig));
      _isBackupConfigured = true;

      Utils.logPrint('Successfully configured both auth pools');
    } on Exception catch (e) {
      Utils.logPrint('Error configuring Amplify: $e');
      rethrow;
    }
  }

  Future<ApiResponse> signInUser({
    BuildContext? context,
    String? username,
    String? password,
  }) async {
    // Try primary pool first
    if (_isPrimaryConfigured && !_usingBackupPool) {
      try {
        final signInResponse = await _primaryAuth.signIn(
          username: username ?? "",
          password: password ?? "",
        );

        return ApiResponse<SignInResult>(
          data: signInResponse,
          statusCode: AMPLIFY_SUCCESS,
        );
      } catch (e) {
        Utils.logPrint('Primary pool sign-in failed: $e');
        // If primary fails, try backup pool
        if (_isBackupConfigured) {
          return _tryBackupPoolSignIn(context, username, password);
        }
        return _handleSignInError(context, e);
      }
    } else if (_isBackupConfigured) {
      return _tryBackupPoolSignIn(context, username, password);
    }

    return ApiResponse<SignInResult>(
      error: "No authentication pools available",
      statusCode: AMPLIFY_ERROR,
    );
  }

  Future<ApiResponse> _tryBackupPoolSignIn(
    BuildContext? context,
    String? username,
    String? password,
  ) async {
    try {
      final signInResponse = await _backupAuth.signIn(
        username: username ?? "",
        password: password ?? "",
      );
      _usingBackupPool = true;
      return ApiResponse<SignInResult>(
        data: signInResponse,
        statusCode: AMPLIFY_SUCCESS,
      );
    } catch (e) {
      return _handleSignInError(context, e);
    }
  }

  ApiResponse _handleSignInError(BuildContext? context, dynamic error) {
    Utils.logPrint('Error signing in: $error');
    if (context != null) {
      dynamic er = jsonDecode(jsonEncode(error));
      snackBar(context, er["message"]);
    }
    return ApiResponse<SignInResult>(
      error: jsonDecode(jsonEncode(error.toString())).toString(),
      statusCode: AMPLIFY_ERROR,
    );
  }

  Future<ApiResponse> signUpUser(
    BuildContext context, {
    String? username,
    String? password,
    String? firstName,
    String? lastName,
  }) async {
    final authService = _usingBackupPool ? _backupAuth : _primaryAuth;

    try {
      final userData = await authService.signUp(
        username: username ?? "",
        password: password ?? "",
        options: SignUpOptions(
          userAttributes: <AuthUserAttributeKey, String>{
            AuthUserAttributeKey.familyName: lastName ?? "",
            AuthUserAttributeKey.givenName: firstName ?? "",
            AuthUserAttributeKey.picture: "default",
            AuthUserAttributeKey.updatedAt:
                DateTime.now().millisecondsSinceEpoch.toString(),
          },
        ),
      );

      return ApiResponse<SignUpResult>(
        data: userData,
        statusCode: AMPLIFY_SUCCESS,
      );
    } on UsernameExistsException catch (e) {
      return ApiResponse<SignUpResult>(
        error: e.message,
        statusCode: AMPLIFY_USER_SIGNUP_ALREADY_EXIST,
      );
    } catch (e) {
      return ApiResponse<SignUpResult>(
        error: jsonDecode(jsonEncode(e.toString())).toString(),
        statusCode: AMPLIFY_ERROR,
      );
    }
  }

  Future<void> switchToBackupPool() async {
    if (_isBackupConfigured) {
      _usingBackupPool = true;
      // Re-authenticate user if needed
      await getCurrentUser();
    }
  }

  Future<void> switchToPrimaryPool() async {
    if (_isPrimaryConfigured) {
      _usingBackupPool = false;
      // Re-authenticate user if needed
      await getCurrentUser();
    }
  }

  // Get current user's details from active pool
  Future<void> getCurrentUser() async {
    try {
      final authService = _usingBackupPool ? _backupAuth : _primaryAuth;
      _currentUser = await authService.getCurrentUser();
      final attributes = await authService.fetchUserAttributes();

      _userDetails = {};
      for (final attribute in attributes) {
        _userDetails![attribute.userAttributeKey.toString()] = attribute.value;
      }

      Utils.logPrint(_userDetails);
    } on AuthException catch (e) {
      Utils.logPrint('Failed to get user details: ${e.message}');
      // If primary pool fails, try backup
      if (!_usingBackupPool && _isBackupConfigured) {
        await switchToBackupPool();
        await getCurrentUser();
      }
    }
  }

// Additional methods would be implemented similarly, using the active pool
// and falling back to backup pool when needed
}
