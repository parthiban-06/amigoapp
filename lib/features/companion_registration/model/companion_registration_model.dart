import 'package:flutter/material.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

class CompanionRegistrationModel extends BaseProvider {
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();

  bool isMinor = false;

  void init() {}

  validStateChange() {
    setState();
    if (formKey.currentState != null) {}
  }

  minorCheckBox() {
    isMinor = !isMinor;
    setState();
  }

  companionRegistrationSubmitButton() {
    // submit button
    // CompanionRegistration code here
  }
}
