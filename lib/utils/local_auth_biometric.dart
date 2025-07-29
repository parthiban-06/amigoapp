import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:visaamigo/utils/utils.dart';

class AutoBiometricInit {
  AutoBiometricInit._();

  static final AutoBiometricInit _instance = AutoBiometricInit._();

  factory AutoBiometricInit() => _instance;

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final check = await checkBiometricSupport();

      if (check) {
        return getBiometrics();
      } else {
        return false;
      }
    } catch (e) {
      Utils.logPrint("authenticate Error: $e");
      return false;
    }
  }

  Future<bool> checkBiometricSupport() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      return canAuthenticate;
    } catch (e) {
      Utils.logPrint("Error check: $e");
      return false;
    }
  }

  Future<bool> getBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        authMessages: [],
        options:
            const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
      );
      return authenticated;
    } on PlatformException catch (e) {
      Utils.logPrint("Auth platform exception: ${e.code}");
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.passcodeNotSet ||
          e.code == auth_error.notEnrolled) {
        return false;
      } else if (e.code == 'UserCanceled' || e.code == 'UserFallback') {
        // These are string error codes returned by the platform
        return false;
      }
      return false;
    } catch (e) {
      Utils.logPrint("Error auth: $e");
      return false;
    }
  }
}
