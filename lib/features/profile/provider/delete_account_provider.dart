import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/generic_dialog.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/encryption_AES_GCM.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/app_const.dart';
import '../../../utils/validation.dart';
import '../../itinerary/providers/itinerary_provider.dart';
import '../../splash_screen/repo/user_detail_repo.dart';
import '../model/delete_user_response.dart';

class DeleteAccountProvider extends BaseProvider with WidgetsBindingObserver {
  final UserDetailRepo userDetailRepo;

  DeleteAccountProvider({required this.userDetailRepo});

  final formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  bool isCompanion = false;
  List<String> formValid = [""];
  String? errorText;
  bool showError = false;
  bool atLeastOneOfEachChar = false;
  bool atLeast8Character = false;
  bool isDisable = true;

  UserModel? userModel;
  String? email;

  init() async {
    //TODO @Riddhi
    isCompanion = await Preferences.getBool(Preferences.isCompanion);
    setState();
  }

  void getUserEmail() async {
    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);
    email = userModel!.email;
  }

  void validate(String valid) {
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

  void checkError(String error) {
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

  void onShowError() {
    showError = true;
    setState();
  }

  validPassState(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    errorText = null;
    showError = true;
    setState();

    if (Validation.everyChar.hasMatch(password.text.trim())) {
      atLeastOneOfEachChar = true;
    } else {
      atLeastOneOfEachChar = false;
    }

    if (password.text.trim().length >= 8 && password.text.trim().length <= 20) {
      atLeast8Character = true;
    } else {
      atLeast8Character = false;
    }

    setState();

    checkDisable();
  }

  void checkDisable() {
    isDisable = !(password.text.trim().length >= 6 &&
        atLeastOneOfEachChar &&
        atLeast8Character);
    setState();
  }

  /// Shows an delete account dialog similar to the one in the example
  Future<void> showDeleteAccountDialog(BuildContext context) async {
    WidgetsBinding.instance.addObserver(this);
    var isConfirmClick = await context.showDeleteAccountDialog(
        context: context,
        title: S.of(context).delete_your_account,
        backgroundColor: VisaColors.dialogBgColor,
        barrierDismissible: false,
        buttonText: S.of(context).confirm,
        buttonBgColor: VisaColors.red,
        dialogRouteName: "delete_your_account_dialog");
    WidgetsBinding.instance.removeObserver(this);
    if (isConfirmClick != null && isConfirmClick) {
      Utils.removeFocus();
      await Future.delayed(const Duration(milliseconds: 150));
      deleteAccount();
    } else {
      enableMFA();
      Utils.logPrint("clicked on close button");
    }
  }

  Future<void> checkConfirmPassword() async {
    formValid = [
      S.of(getContext()).enter_your_password,
    ];
    showError = true;
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;

    try {
      // final result = await amplifyService.verifyPasswordWithCognito(
      //     username: email!, password: password.toTrimmedString());
      //
      // if (result.isValid) {
      //   showDeleteAccountDialog(getContext());
      // } else {
      //   checkError(result.errorMessage!);
      // }

      await checkMFA();

      final pasWod =
          await EncryptionHelperGCM.encrypt(password.toTrimmedString());

      Map<String, dynamic> passwordMap = {"password": pasWod};

      final response = await userDetailRepo.authenticatePassword(
        passwordMap,
        DeleteUserResponse.fromJson,
      );

      if (response.isSuccess) {
        showDeleteAccountDialog(getContext());
      } else {
        checkError(Utils.getErrorMessageFromString(AppConst.invalidPassword));
      }

      isLoading = false;
    } catch (e) {
      Utils.logPrint(e);
      isLoading = false;
    }
  }

  checkMFA() async {
    final bool mfa = await Preferences.getBool(Preferences.enableMfa);
    if (mfa == true) {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      await cognitoPlugin.updateMfaPreference(
          sms: MfaPreference.disabled, email: MfaPreference.disabled);
      await Preferences.setBool(Preferences.enableMfa, false);
      await Preferences.setBool(Preferences.enableMfaTemp, true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      enableMFA();
    } else if (state == AppLifecycleState.resumed) {
      checkMFA();
    }
  }

  enableMFA() async {
    final bool mfa = await Preferences.getBool(Preferences.enableMfaTemp);
    if (mfa == true) {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      await cognitoPlugin.updateMfaPreference(
          sms: MfaPreference.disabled, email: MfaPreference.enabled);
      await Preferences.setBool(Preferences.enableMfa, true);
      await Preferences.setBool(Preferences.enableMfaTemp, false);
    }
  }

  // Function to delete User Account
  Future<void> deleteAccount() async {
    isLoading = true;
    final response =
        await userDetailRepo.deleteAccount(DeleteUserResponse.fromJson);

    if (response?.isSuccess == true && response?.data != null) {
      FirebaseAnalyticsService.logEvent(eventName: "accountdelete_success");
      logoutUser();
    } else {
      isLoading = false;
      visaSnackBar(
        context: getContext(),
        title: "${S.of(getContext()).error}!",
        type: SnackBarType.failure,
        subtitle: S.of(getContext()).failed_to_delete_account,
      );
    }
  }

  Future<void> logoutUser() async {
    await AmplifyService().signOutUser();
    Utils.removeFocus();
    await Future.delayed(const Duration(milliseconds: 150));
    isLoading = false;
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    if (context.mounted) {
      Provider.of<ItineraryProvider>(context, listen: false)
          .resetCalendarState();
    }
    navigateToDeletedAccountScreen();
  }

  // Navigate to Confirm Delete Account Screen
  void navigateToConfirmDeleteAccountScreen() {
    navPush(AppRoutes.confirmDeleteAccount);
  }

  // Navigate to Deleted Account Screen
  void navigateToDeletedAccountScreen() {
    navGo(AppRoutes.deletedAccount);
  }

  void navigateToRegisteredEmailScreen() {
    navGo(AppRoutes.registeredEmail);
  }

  // Navigate to the Close Screen
  void closeScreen() {
    navPop();
  }
}
