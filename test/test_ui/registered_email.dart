import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/remote/api_client.dart';
import 'package:visaamigo/remote/api_response.dart';
import 'package:visaamigo/utils/app_const.dart';

import '../test_mock/mock_login.dart';
import 'registered_email.mocks.dart';

// Generate a mock class
@GenerateMocks([http.Client, UserDetailRepo, ApiClient])
void main() {
  late MockLogin loginViewModel;
  late MockUserDetailRepo mockDetailRepo;

  setUp(() {
    loginViewModel = MockLogin();
    mockDetailRepo = MockUserDetailRepo(); // Correct way to mock
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

  group('Login Functionality', () {
    test('Should return 404 error when user is not valid', () async {
      when(mockDetailRepo.getIsValidUser(
              "test@gmail.com", UserModel.fromJson, AppConst.USER_VALIDATION))
          .thenAnswer(
              (_) async => ApiResponse(error: "Error", statusCode: 404));

      final response = await mockDetailRepo.getIsValidUser(
          "test@gmail.com", UserModel.fromJson, AppConst.USER_VALIDATION);

      expect(response.statusCode, 404);
      expect(response.error, "Error");
    });
  });
}
