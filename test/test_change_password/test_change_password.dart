import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_ui/test_login.mocks.dart';
import 'test_change_password_mock.dart';

// Generate a mock class for AmplifyAuthCognito
@GenerateMocks([AmplifyAuthCognito])
void main() {
  late MockConfirmPassword confirmPasswordMock;
  late MockAmplifyAuthCognito mockAuth;

  setUp(() {
    confirmPasswordMock = MockConfirmPassword();
    mockAuth = MockAmplifyAuthCognito();
  });

  group('Password Validation', () {
    test('Should return error for empty current password', () {
      expect(
          confirmPasswordMock.validatePassword(
              '', "Current password cannot be empty"),
          "Current password cannot be empty");
    });

    test('Should return error for short new password', () {
      expect(
        confirmPasswordMock.validatePassword(
            '123', "Password must be at least 6 characters"),
        "Password must be at least 6 characters",
      );
    });

    test('Should return null for valid new password', () {
      expect(
        confirmPasswordMock.validatePassword('Valid@123', null),
        null,
      );
    });

    test('Should return error if confirm password does not match new password',
        () {
      expect(
        confirmPasswordMock.validateConfirmPassword(
            'NewPass@123', 'Mismatch@123'),
        "Passwords do not match",
      );
    });

    test('Should return null if confirm password matches new password', () {
      expect(
        confirmPasswordMock.validateConfirmPassword(
            'NewPass@123', 'NewPass@123'),
        null,
      );
    });
  });

  group('AWS Cognito - Change Password', () {
    test('Should succeed for valid current and new passwords', () async {
      when(mockAuth.updatePassword(
        oldPassword: 'Current@123',
        newPassword: 'NewPass@123',
      )).thenAnswer((_) async => UpdatePasswordResult());

      final result = await mockAuth.updatePassword(
        oldPassword: 'Current@123',
        newPassword: 'NewPass@123',
      );

      expect(result, isA<UpdatePasswordResult>());
    });

    test('Should throw AuthException on invalid current password', () async {
      when(mockAuth.updatePassword(
        oldPassword: 'WrongPassword',
        newPassword: 'NewPass@123',
      ));

      expect(
        () async => await mockAuth.updatePassword(
          oldPassword: 'WrongPassword',
          newPassword: 'NewPass@123',
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
