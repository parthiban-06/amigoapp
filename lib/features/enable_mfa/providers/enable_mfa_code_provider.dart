import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/remote/aws_api/aws_api_model.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../custom_widgets/snackbar.dart';
import '../../../remote/aws_api/aws_api_service.dart';
import '../../../remote/aws_api/aws_repository.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/amplify_service.dart';
import '../../../utils/app_const.dart';
import '../../signup/model/user_model.dart';

class EnableMfaCodeProvider extends BaseProvider {
  final formKey = GlobalKey<FormState>();

  TextEditingController code = TextEditingController();

  bool pageLoad = false;
  bool isSignUp = false;
  UserModel? userModel;

  validStateChange() {
    setState();
    if (formKey.currentState != null) {}
  }

  final awsRepository = AwsRepository<UserModel>(
    apiService: AwsApiService(
      apiGatewayId: dotenv.env['API_GATEWAY_ID_USER_PROFILE']!,
    ),
    model: AwsApiModel<UserModel>(
      endpoint: AppConst.PATH_USER_PROFILE,
      parser: UserModel.fromJson,
    ),
  );

  void init(UserModel userModel) {
    setState();
    this.userModel = userModel;
  }

  signIn() {
    navPush(AppRoutes.login);
  }

  signInUser() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    isLoading = true;
    await amplifyService.signInUser(
        context: context,
        username: userModel?.email,
        userLanguage: await Preferences.getString(Preferences.keyLanguageCode),
        password: userModel?.passowrd);

    isLoading = false;

    loadHomePage();
  }

  verifyMfaCode() async {
    //verify mfa code

    final rep = await amplifyService.confirmMfaSignIn(code.text.trim());

    // Capture context before async operations
    final context = getContext();
    if (!context.mounted) return;

    if (rep != null) {
      if (rep.statusCode == AmplifyService.AMPLIFY_SUCCESS) {
      } else {
        snackBar(context, S.of(context).try_again);
      }
    } else {
      snackBar(context, S.of(context).try_again);
    }
  }

  Future<void> createUser() async {
    userModel?.userId = amplifyService.currentUser?.userId ?? "";
    userModel?.id = amplifyService.currentUser?.userId ?? "";
    userModel?.termsAccepted = true;
    userModel?.preferredLanguage =
        await Preferences.getString(Preferences.keyLanguageCode);

    isLoading = true;

    final response = await awsRepository.create(userModel!.toAwsJson());

    isLoading = false;

    // Capture context before async operations
    final context = getContext();
    if (!context.mounted) return;

    if (response!.success) {
      snackBar(context, S.of(context).welcome);
      navPush(AppRoutes.homeNav);
    }
  }

  signUp() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    final rep = await amplifyService.confirmSignUpUser(
        context: context, username: userModel?.email, code: code.text);

    if (rep.data != null && rep.data.isSignUpComplete) {
      signInUser();
    } else if (context.mounted) {
      snackBar(context, S.of(context).something_went_wrong);
    }
  }

  resendCode() async {
    code.text = "";
    setState();
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    await Amplify.Auth.resendSignUpCode(
        username: await Preferences.getString(Preferences.email));
    if (context.mounted) {
      snackBar(context, S.of(context).code_send);
    }
  }

  void loadHomePage() async {
    bool isGettingToKnowDone =
        await Preferences.getBool(Preferences.isGettingToKnowDone);
    if (!isGettingToKnowDone) {
      navGo(AppRoutes.aiAssistantWelcomeScreen);
    } else {
      navGo(AppRoutes.homeNav);
    }
  }
}
