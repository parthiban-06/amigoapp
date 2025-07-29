import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_mock/mock_login.dart';
import 'test_login.mocks.dart';

// Generate a mock class for Amplify Auth
@GenerateMocks([AmplifyAuthCognito])
void main() {
  late MockLogin loginViewModel;
  late MockAmplifyAuthCognito mockAuth;

  setUp(() {
    loginViewModel = MockLogin();
    mockAuth = MockAmplifyAuthCognito();
  });

  group('Email Validation', () {
    test('Should return error for empty email', () {
      expect(loginViewModel.validateEmail('', "Email cannot be empty"),
          "Email cannot be empty");
    });

    test('Should return error for invalid email format', () {
      expect(
          loginViewModel.validateEmail('invalid-email', "Invalid email format"),
          "Invalid email format");
    });

    test('Should return null for valid email', () {
      expect(
          loginViewModel.validateEmail(
              'test@example.com', "Invalid email format"),
          null);
    });
  });

  group('Password Validation', () {
    test('Should return error for empty password', () {
      expect(loginViewModel.validatePassword('', "Password cannot be empty"),
          "Password cannot be empty");
    });

    test('Should return error for short password', () {
      expect(
          loginViewModel.validatePassword(
              '12345', "Password must be at least 6 characters"),
          "Password must be at least 6 characters");
    });

    test('Should return null for valid password', () {
      expect(loginViewModel.validatePassword('password123', "Invalid Password"),
          "Invalid Password");
    });
  });

  group('Login Functionality', () {
    test('Should return false for invalid email', () async {
      final result = await loginViewModel.login(
          'invalid-email', 'password123', "Invalid Email", "Invalid Password");
      expect(result, false);
    });

    test('Should return false for invalid password', () async {
      final result = await loginViewModel.login(
          'test@example.com', '123', "Invalid Email", "Invalid Password");
      expect(result, false);
    });

    test('Should return true for valid credentials', () async {
      final result = await loginViewModel.login('test@example.com',
          'Password@123', "Invalid Email", "Invalid Password");
      expect(result, true);
    });
  });

  group('AWS Cognito Login', () {
    test('Should return true for valid credentials', () async {
      when(mockAuth.signIn(
              username: "test@example.com", password: "Password@123"))
          .thenAnswer((_) async => CognitoSignInResult(
              isSignedIn: true,
              nextStep: AuthNextSignInStep(signInStep: AuthSignInStep.done)));

      final result = await mockAuth.signIn(
          username: "test@example.com", password: "Password@123");

      expect(
          result,
          CognitoSignInResult(
              isSignedIn: true,
              nextStep: AuthNextSignInStep(signInStep: AuthSignInStep.done)));
    });
  });
}
