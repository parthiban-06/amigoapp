import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../ui/base/base_provider.dart';

class EditProfileModel extends BaseProvider {
  final formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  UserModel? userModel;
  final forbiddenCharactersRegex = RegExp(r'[<>{}]');

  bool showError = false;
  String? errorText;
  List<String> formValid = [];
  List<Map<String,dynamic>> formError = [];
  String changeFirstName = "";
  String changeLastName = "";

  Future<void> init() async {
    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);
    if (userModel != null) {
      email.text = userModel!.email;
      firstName.text = userModel!.firstName;
      lastName.text = userModel!.lastName;
      changeFirstName = userModel!.firstName;
      changeLastName = userModel!.lastName;
    }
    setState();
  }

  onShowError() {
    showError = true;
    setState();
  }

  void addToFormError(Map<String,dynamic> error){
    bool exists = formError.any((map) =>
    map.length == error.length &&
        map.entries.every((entry) => error[entry.key] == entry.value));
    if(!exists){
      formError.add(error);
    }
  }

  /// Form error
  void _formError(){
    Future.delayed(const Duration(milliseconds: 350),(){
      String errorField = formError
          .map((map) => map['label'])
          .where((name) => name != null)
          .join(', ');
      String errorMessage = formError
          .map((map) => map['error'])
          .where((name) => name != null)
          .join(', ');
      FirebaseAnalyticsService.logEvent(
        eventName: "editprofile.form.error",
        parameters: {
          AnalyticsEventConst.FORM_NAME: "form_edit_profile",
          AnalyticsEventConst.FORM_ID: "edit_profile_page",
          "error_field": errorField,
          "error_type": errorMessage,
          "error_message": errorMessage,
        },
      );
      Utils.logPrint("Errors: $formError");
    });
  }

  validStateChanges(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    formError.clear();
    errorText = null;
    showError = true;
    setState();
  }

  validate(String valid) {
    if (!formValid.contains(valid)) {
      formValid.add(valid);
    }
    _formError();
    setState();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (showError == true && formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  checkError(String error) {
    formValid = [];
    showError = true;
    errorText = error;
    setState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  Future<void> updateUserName(
      {required String firstName, required String lastName}) async {
    try {
      formValid = [
        S.of(getContext()).email_is_required,
        S.of(getContext()).first_name,
        S.of(getContext()).last_name,
      ];
      showError = true;
      errorText = null;
      setState();
      await Future.delayed(const Duration(milliseconds: 150));
      if (!(formKey.currentState != null && formKey.currentState!.validate())) {
        _formError();
        return;
      }

      if (changeFirstName == firstName && changeLastName == lastName) {
        return;
      }

      isLoading = true;
      setState();

      final result = await Amplify.Auth.updateUserAttributes(attributes: [
        AuthUserAttribute(
            userAttributeKey: AuthUserAttributeKey.givenName, value: firstName),
        AuthUserAttribute(
            userAttributeKey: AuthUserAttributeKey.familyName, value: lastName)
      ]);

      bool showSuccessSnackBar = false;

      result.forEach((key, updateResult) {
        if (updateResult.nextStep.updateAttributeStep ==
            AuthUpdateAttributeStep.confirmAttributeWithCode) {
          Utils.logPrint(
              'Verification required for ${key.key}: Code sent to ${updateResult.nextStep.codeDeliveryDetails?.destination}');
        } else {
          Utils.logPrint('${key.key} updated successfully!');
          showSuccessSnackBar = true;
        }
      });

      await Preferences.setString(Preferences.firstName, firstName);
      await Preferences.setString(Preferences.lastName, lastName);
      UserModel userData = UserModel(
          email: email.text, firstName: firstName, lastName: lastName);
      await Preferences.setModelData(
          Preferences.KeyUserModel, userData.toJson());
      Provider.of<UserGenericProvider>(getContext(), listen: false)
          .updateUserModel();
      amplifyService.userNameInitial = firstName[0].toUpperCase();
      isLoading = false;
      setState();

      // Show toast only once if any attribute was successfully updated
      if (showSuccessSnackBar) {
        visaSnackBar(
          context: getContext(),
          title: "${S.of(getContext()).success}!",
          type: SnackBarType.success,
          duration: const Duration(seconds: 1),
          subtitle: S.of(getContext()).profile_updated_successfully,
        );
        await Future.delayed(const Duration(seconds: 1));
      }

      Navigator.of(getContext()).pop();
    } on AuthException catch (e) {
      Utils.logPrint('Error updating user attributes: ${e.message}');
      isLoading = false;
      setState();
    }
  }
}
