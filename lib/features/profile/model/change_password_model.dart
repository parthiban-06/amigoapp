import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:visaamigo/features/profile/model/send_email_response_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class ChangePasswordModel extends BaseProvider {
  final formKey = GlobalKey<FormState>();

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  bool atLeast8Character = false;
  bool atLeastOneOfEachChar = false;
  bool showError = false;
  String? errorText;
  List<String> formValid = [];

  Future<void> init() async {
    setState();
  }

  onShowError() {
    showError = true;
    setState();
  }

  validStateChanges(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    errorText = null;
    showError = true;
    setState();

    if (Validation.everyChar.hasMatch(newPassword.text)) {
      atLeastOneOfEachChar = true;
    } else {
      atLeastOneOfEachChar = false;
    }

    if (newPassword.text.trim().length >= 8 &&
        newPassword.text.trim().length <= AppConst.TEXTFIELD_DEFAULT_LENGTH) {
      atLeast8Character = true;
    } else {
      atLeast8Character = false;
    }

    setState();
  }

  validate(String valid) {
    if (!formValid.contains(valid)) {
      formValid.add(valid);
    }
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

  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    formValid = [
      S.of(getContext()).current_password,
      S.of(getContext()).new_pass,
      S.of(getContext()).cnf_pass,
    ];
    showError = true;
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!(formKey.currentState != null && formKey.currentState!.validate())) {
      return;
    }

    try {
      isLoading = true;
      setState();
      await Amplify.Auth.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      await updateChangePassword();
      isLoading = false;
      setState();
      Navigator.of(getContext()).pop();
      visaSnackBar(
          context: getContext(),
          title: "${S.of(getContext()).success}!",
          type: SnackBarType.success,
          subtitle: S.of(getContext()).password_change_success);

      //Your password has been updated successfully.
    } on LimitExceededException catch (e) {
      isLoading = false;
      checkError(S.of(getContext()).limit_exceed);
      setState();
    } on AuthException catch (e) {
      isLoading = false;
      checkError(S.of(getContext()).incorrect_current_password);
      setState();
    }
  }

  Future<void> updateChangePassword() async {
    UserDetailRepo userDetailRepo = UserDetailRepo(apiClient);
    // ⚠️ API currently expects query parameters instead of body — to be fixed later
    final emptyBody = <String, dynamic>{};

    final langCode = await Preferences.getString(Preferences.keyLanguageCode);

    final response = await userDetailRepo.sendEmail(
      emptyBody,
      SendEmailResponse.fromJson,
      AppConst.changePassword,
      langCode,
    );

    if (response.isSuccess == true && response.data != null) {
      // TODO: Handle success case here (e.g., show toast, navigate, etc.)
    }
  }
}
