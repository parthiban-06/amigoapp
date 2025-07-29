import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import '../../../generated/assets.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../signup/model/user_model.dart';
import '../../splash_screen/repo/user_detail_repo.dart';
import '../models/language_selection_model.dart';
import 'language_selection_generic_provider.dart';

class SelectLanguageProvider extends BaseProvider {
  String? _selectedLanguage;
  Language? selectedLanguageItem;
  String? initialLanguage;
  List<Language>? languageList;
  UserDetailRepo? userDetailRepo;
  SelectLanguageGenericProvider? languageGenericProvider;

  Future<void> loadSavedLocale() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    Utils.logPrint(",loadSavedLocale");
    final String? languageCode =
        await Preferences.getString(Preferences.keyLanguageCode);

    if (!languageCode.isNullOrEmpty) {
      _selectedLanguage = languageCode;
      initialLanguage = languageCode;
    } else if (context != null) {
      Locale deviceLocal = Localizations.localeOf(context);

      _selectedLanguage = deviceLocal.languageCode;
      initialLanguage = deviceLocal.languageCode;
    }

    languageGenericProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);
    setState();
  }

  Future<void> init() async {
    Utils.logPrint(",loadSavedLocale init");

    if (languageList == null || languageList!.isEmpty) {
      languageList = languageSelectionModelFromJsonList(
          await Utils.loadJson(Assets.jsonLanguages));
      setState();
    }

    // Set selectedLanguageItem to the language from languageList where langCode matches _selectedLanguage
    if (languageList != null && _selectedLanguage != null) {
      selectedLanguageItem = languageList!.firstWhere(
        (language) => language.langCode == _selectedLanguage,
        orElse: () =>
            languageList!.first, // fallback to first language if not found
      );
    }

    userDetailRepo = UserDetailRepo(apiClient);
  }

  String get selectedLanguage => _selectedLanguage ?? "";

  Future<void> setLanguage(Language language) async {
    _selectedLanguage = language.langCode;
    selectedLanguageItem = language;

    languageGenericProvider?.updateLanguageCode(language.langCode);
    isLoading = false;
    setState();

    Utils.announceMessage(language.title + S.of(getContext()).selected);
  }

  onBack() async {
    String code = await Preferences.getString(Preferences.keyLanguageCode);
    // ignore: use_build_context_synchronously
    Provider.of<SelectLanguageGenericProvider>(mContext, listen: false)
        .setLanguage(code);
    setState();
    // Navigator.of(getContext()).pop();
  }

  Future<void> navigateToLogin(String? deeplink) async {
    Utils.logPrint(
        ", _selectedLanguage! ${_selectedLanguage!} == $selectedLanguage");
    await Preferences.setString(
        Preferences.keyLanguageCode, _selectedLanguage!);

    if (deeplink == null || deeplink.isNullOrEmpty) {
      navGo(AppRoutes.registeredEmail, extra: null);
    } else {
      UserModel userModel = UserModel();
      userModel.email = deeplink;

      navGo(AppRoutes.registeredEmail, extra: userModel);
    }
  }

  Future<bool> updateLanguage(String languageCode, bool showBack) async {
    isLoading = true;
    setState();

    try {
      // Update local language immediately
      _selectedLanguage = languageCode;
      languageGenericProvider?.setLanguage(languageCode);
      languageGenericProvider?.loadArbFile(languageCode);

      // Update user model if available
      UserModel? userModel = await Preferences.getModelData(
          Preferences.KeyUserModel, UserModel.fromJson);

      if (userModel != null) {
        userModel.preferredLanguage = languageCode;
        await Preferences.setModelData(Preferences.KeyUserModel, userModel);
      }

      // Update on server if showBack is true (language change from settings)
      if (showBack && userModel != null) {
        final response = await userDetailRepo?.updateUserDetail(
            userModel.toAwsJson(), UserModel.fromJson);
        isLoading = false;
        setState();
        return response?.isSuccess ?? false;
      }

      isLoading = false;
      setState();
      return true;
    } catch (e) {
      Utils.logPrint("Error updating language: $e");
      isLoading = false;
      setState();
      return false;
    }
  }
}
