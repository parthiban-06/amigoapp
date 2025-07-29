import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/signup/providers/signup_provider.dart';

import '../test_mock/mock_signup.dart';
import 'test_login.mocks.dart';

// Generate a mock class for Amplify Auth
@GenerateMocks([AmplifyAuthCognito])
void main() {
  late SignUpViewProvider signUpViewProvider;
  late MockSignup signUpModel;
  late MockAmplifyAuthCognito mockAuth;

  setUp(() {
    signUpViewProvider = SignUpViewProvider();
    signUpModel = MockSignup();
    mockAuth = MockAmplifyAuthCognito();
  });

  group('Email Validation', () {
    test('Should return error for empty email', () {
      expect(signUpModel.validateEmail('', "Email cannot be empty"),
          "Email cannot be empty");
    });

    test('Should return error for invalid email format', () {
      expect(signUpModel.validateEmail('invalid-email', "Invalid email format"),
          "Invalid email format");
    });

    test('Should return null for valid email', () {
      expect(
          signUpModel.validateEmail('test@example.com', "Invalid email format"),
          null);
    });
  });

  group('Password Validation', () {
    test('Should return error for empty password', () {
      expect(signUpModel.validatePassword('', "Password cannot be empty"),
          "Password cannot be empty");
    });

    test('Should return error for short password', () {
      expect(
          signUpModel.validatePassword(
              '12345', "Password must be at least 6 characters"),
          "Password must be at least 6 characters");
    });

    test('Should return null for valid password', () {
      expect(signUpModel.validatePassword('password123', "Invalid Password"),
          "Invalid Password");
    });
  });

  group('Login Functionality', () {
    test('Should return false for invalid email', () async {
      final result = await signUpModel.login(
          'invalid-email', 'password123', "Invalid Email", "Invalid Password");
      expect(result, false);
    });

    test('Should return false for invalid password', () async {
      final result = await signUpModel.login(
          'test@example.com', '123', "Invalid Email", "Invalid Password");
      expect(result, false);
    });

    test('Should return true for valid credentials', () async {
      final result = await signUpModel.login('test@example.com', 'Password@123',
          "Invalid Email", "Invalid Password");
      expect(result, true);
    });
  });

  group('AWS Cognito SignUp', () {
    test('Should return true for valid credentials', () async {
      when(mockAuth.signUp(
              username: "test@example.com", password: "Password@123"))
          .thenAnswer((_) async => CognitoSignUpResult(
              isSignUpComplete: true,
              nextStep: AuthNextSignUpStep(signUpStep: AuthSignUpStep.done)));

      final result = await mockAuth.signUp(
          username: "test@example.com", password: "Password@123");

      expect(
          result,
          CognitoSignUpResult(
              isSignUpComplete: true,
              nextStep: AuthNextSignUpStep(signUpStep: AuthSignUpStep.done)));
    });
  });
}
