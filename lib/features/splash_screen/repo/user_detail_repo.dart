import '../../../remote/api_client.dart';
import '../../../remote/api_response.dart';
import '../../../utils/app_const.dart';

class UserDetailRepo {
  final ApiClient apiClient;

  UserDetailRepo(this.apiClient);

  Future<ApiResponse<T>> getIsValidUser<T>(
    String deepLinkEmail,
    T Function(Map<String, dynamic> json) fromJson,
    String responseKey,
  ) async {
    return await apiClient.get(
        endpoint: "${AppConst.USER_VALIDATION}/$deepLinkEmail",
        fromJson: fromJson,
        addAuthHeader: false);
  }

  Future<ApiResponse<T>> saveUserDetail<T>(
      dynamic body, T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.post(
      endpoint: AppConst.USER_PROFILES,
      body: body,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> updateUserDetail<T>(
      dynamic body, T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.patch(
      endpoint: AppConst.USER_PROFILES,
      body: body,
      fromJson: fromJson,
    );
  }

  // TODO Dhruvil
  Future<ApiResponse<T>> updateUserPreference<T>(
      String endpoint,
      dynamic body,
      T Function(Map<String, dynamic> json) fromJson,
      bool isJsonRequired) async {
    return await apiClient.patch(
      endpoint: AppConst.USER_PREFERENCE + endpoint,
      body: body,
      isJsonRequired: isJsonRequired,
      fromJson: fromJson,
    );
  }

  // TODO Dhruvil
  Future<ApiResponse<T>> updateUserPreferenceKnowYourUser<T>(
      dynamic body,
      T Function(Map<String, dynamic> json) fromJson,
      bool isJsonRequired) async {
    return await apiClient.patch(
      endpoint: AppConst.USER_PREFERENCE + "?update_type=know_your_user",
      body: {"preferences": body},
      isJsonRequired: isJsonRequired,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> getFAQ<T>(
    T Function(Map<String, dynamic> json) fromJson,
    String lang,
    String platformKey,
  ) async {
    return await apiClient.get(
        endpoint:
            AppConst.FAQ + "preferred_language=$lang&platform_key=$platformKey",
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getOpenFAQ<T>(
    T Function(Map<String, dynamic> json) fromJson,
    String lang,
    String platformKey,
  ) async {
    return await apiClient.get(
        endpoint:
            "${AppConst.OPEN_FAQ}preferred_language=$lang&platform_key=$platformKey",
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getUserInfo<T>(
    T Function(Map<String, dynamic> json) fromJson,
    String responseKey,
  ) async {
    return await apiClient.get(
      endpoint: AppConst.USER_PROFILES,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> getUserPreference<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
      endpoint: AppConst.USER_PREFERENCE_GET,
      fromJson: fromJson,
      isJsonRequired: false,
      isDataNodePresent: false,
    );
  }

  Future<ApiResponse<T>> getUserPreference2<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
      endpoint: AppConst.USER_PREFERENCE_GET,
      fromJson: fromJson,
      isDataNodePresent: false,
    );
  }

  Future<ApiResponse<T>> rateUs<T>(
      T Function(Map<String, dynamic> json) fromJson, dynamic body) async {
    return await apiClient.post(
        endpoint: AppConst.RATE_US,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getRatting<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.RATE_US,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> updateRating<T>(
      T Function(Map<String, dynamic> json) fromJson, dynamic body) async {
    return await apiClient.patch(
        endpoint: AppConst.RATE_US,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getMatches<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
        endpoint: AppConst.MATCHES,
        fromJson: fromJson,
        isDataNodePresent: false,
        isJsonRequired: true);
  }

  Future<ApiResponse<T>> getNotifications<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
        endpoint: AppConst.USER_NOTIFICATIONS,
        fromJson: fromJson,
        isDataNodePresent: false,
        isJsonRequired: true);
  }

  Future<ApiResponse<T>> getAppVersion<T>(
      T Function(Map<String, dynamic> json) fromJson, String device) async {
    return await apiClient.post(
        endpoint: AppConst.APP_VERSION + device,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> getWallet<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.get(
        endpoint: AppConst.WALLET,
        fromJson: fromJson,
        isDataNodePresent: false,
        isJsonRequired: true);
  }

  Future<ApiResponse<T>> updateWallet<T>(
    T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
  ) async {
    return await apiClient.patch(
        endpoint: AppConst.WALLET,
        fromJson: fromJson,
        body: body,
        isDataNodePresent: false,
        isJsonRequired: true);
  }

  Future<ApiResponse<T>> updateNotifications<T>(
      T Function(Map<String, dynamic> json) fromJson,
      dynamic body,
      String id) async {
    return await apiClient.patch(
      endpoint: AppConst.USER_NOTIFICATIONS + "/$id",
      body: body,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> addCompanion<T>(
      T Function(Map<String, dynamic> json) fromJson, dynamic body) async {
    return await apiClient.post(
        endpoint: AppConst.COMPANIONS,
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> editCompanion<T>(
      T Function(Map<String, dynamic> json) fromJson,
      dynamic body,
      String companionId) async {
    return await apiClient.patch(
        endpoint: AppConst.COMPANIONS + "/$companionId",
        body: body,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> listCompanion<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.COMPANIONS,
        fromJson: fromJson,
        isJsonRequired: true,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> companionResendEmail<T>(
      T Function(Map<String, dynamic> json) fromJson,
      String companionId) async {
    return await apiClient.post(
        endpoint: AppConst.COMPANIONS_RESEND_EMAIL + companionId,
        fromJson: fromJson,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> deleteCompanion<T>(
      T Function(Map<String, dynamic> json) fromJson,
      String companionId) async {
    return await apiClient.delete(
        endpoint: AppConst.COMPANIONS + "/$companionId",
        fromJson: fromJson,
        isDataNodePresent: false,
        isJsonRequired: true);
  }

  Future<ApiResponse<T>> sendOTPForgotPassword<T>(
      {required T Function(Map<String, dynamic> json) fromJson,
      required dynamic body}) async {
    return await apiClient.post(
        endpoint: AppConst.SEND_OTP_RESET_PASSWORD,
        body: body,
        fromJson: fromJson,
        addAuthHeader: false,
        isDataNodePresent: false);
  }

  Future<ApiResponse<T>> verifyOTPForgotPassword<T>(
      {required T Function(Map<String, dynamic> json) fromJson,
      required dynamic body}) async {
    return await apiClient.post(
        endpoint: AppConst.VERIFY_OTP_FORGOT_PASSWORD,
        body: body,
        fromJson: fromJson,
        addAuthHeader: false,
        isDataNodePresent: false);
  }

  Future<String> getTermsAndConditions<T>(
    String langCode,
  ) async {
    return await apiClient.getHtml(
      endpoint: AppConst.getTermAndConditions + langCode,
    );
  }

  Future<ApiResponse<T>> deleteAccount<T>(
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.delete(
      endpoint: AppConst.deleteAccount,
      fromJson: fromJson,
      isJsonRequired: true,
      isDataNodePresent: false,
    );
  }

  Future<ApiResponse<T>> authenticatePassword<T>(
    dynamic body,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    return await apiClient.post(
      endpoint: AppConst.authenticatePassword,
      fromJson: fromJson,
      body: body,
      isDataNodePresent: false,
    );
  }

  Future<ApiResponse<T>> getUserConfig<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    return await apiClient.get(
        endpoint: AppConst.USER_CONFIG,
        fromJson: fromJson,
        isDataNodePresent: true);
  }

  Future<ApiResponse<T>> sendEmail<T>(
    dynamic body,
    T Function(Map<String, dynamic> json) fromJson,
    String emailType,
    String langCode,
  ) async {
    return await apiClient.post(
      endpoint: AppConst.sendEmail +
          AppConst.emailType +
          emailType +
          AppConst.prefLang +
          langCode,
      fromJson: fromJson,
      isDataNodePresent: false,
      body: body,
    );
  }
}
