import 'package:flutter/material.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

class MainScreenProvider extends BaseProvider {
  bool _isUserLogin = false;
  bool _isLoginChecked = false;

  bool get isUserLogin => _isUserLogin;

  Future<void> checkUserLoginOnce(BuildContext context) async {
    if (_isLoginChecked) return;

    final authSession = await amplifyService.checkIfSignedIn(context);
    _isUserLogin = authSession?.isSignedIn ?? false;
    _isLoginChecked = true;
    setState();
  }
}
