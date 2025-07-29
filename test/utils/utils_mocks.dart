// test/mocks/utils_mocks.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/local_auth_biometric.dart';

@GenerateMocks([
  LocalAuthentication,
  PackageInfo,
  AmplifyService,
  AutoBiometricInit,
  SelectLanguageGenericProvider,
  BuildContext,
  MediaQueryData,
  TextScaler,
  FocusManager,
  FocusNode,
])
class UtilsMocks {}

// Additional manual mocks for classes that need special handling
class MockLocalAuthentication extends Mock implements LocalAuthentication {}

class MockAutoBiometricInit extends Mock implements AutoBiometricInit {}

class MockAmplifyService extends Mock implements AmplifyService {}

class MockSelectLanguageGenericProvider extends Mock
    implements SelectLanguageGenericProvider {}

// Mock data helpers
class MockTestData {
  static const String validJsonList = '[{"id": 1, "name": "test"}]';
  static const String validJsonMap = '{"id": 1, "name": "test"}';
  static const String invalidJson = '{invalid json}';

  static final Map<String, dynamic> packageInfoData = {
    'version': '1.0.0',
    'buildNumber': '100',
  };

  static const String sampleHexColor = '#FF5733';
  static const String hexColorWithoutHash = 'FF5733';
  static const String shortHexColor = '#F53';
}
