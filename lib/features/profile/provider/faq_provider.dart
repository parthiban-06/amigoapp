import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:visaamigo/features/profile/model/faq_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../ui/base/base_provider.dart';

class FaqProvider extends BaseProvider {
  FaqResponse? faqResponse;
  List<FaqCategory> allFaqCategories = []; // Original list from API
  List<FaqCategory> filteredFaqCategories = []; // Filtered list from API
  UserDetailRepo? userDetailRepo;
  bool? isUserLogin;
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool _isSearchNotEmpty = false;

  bool get isSearchNotEmpty => _isSearchNotEmpty;

  final superToolTipController = SuperTooltipController();

  init() {
    userDetailRepo = UserDetailRepo(apiClient);
    searchController.addListener(_onSearchChanged);
    checkUserSignedIn();
  }

  Future<void> checkUserSignedIn() async {
    AuthSession? userAuthSession =
        await amplifyService.checkIfSignedIn(getContext());
    if (userAuthSession != null && userAuthSession.isSignedIn) {
      isUserLogin = true;
      setState();
      faqApi();
    } else {
      isUserLogin = false;
      setState();
      openFaqApi();
    }
  }

  void _onSearchChanged() {
    final hasText = searchController.text.isNotEmpty;
    if (_isSearchNotEmpty != hasText) {
      _isSearchNotEmpty = hasText;
      setState(); // triggers rebuild
    }
  }

  void clearSearch() {
    searchController.clear();
    _isSearchNotEmpty = false;
    onSearchChanged("");
    setState();
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  final Map<int, bool> _openState = {};

  bool isOpen(int categoryId) => _openState[categoryId] ?? false;

  void setOpen(int categoryId, bool value) {
    _openState[categoryId] = value;
    setState();
  }

  faqApi() async {
    isLoading = true;
    try {
      String ln = await Preferences.getString(Preferences.keyLanguageCode);

      final apiResponse = await userDetailRepo?.getFAQ(
          FaqResponse.fromJson, ln, kIsWeb ? AppConst.web : AppConst.mobile);
      if (apiResponse != null &&
          apiResponse.data != null &&
          apiResponse.data!.messageKey == AppConst.faqRetrieved) {
        faqResponse = apiResponse.data;
        // Store original list
        allFaqCategories = faqResponse!.data;

        // Initially show all
        filteredFaqCategories = List.from(allFaqCategories);

        setState();
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      Utils.logPrint("Error: $e");
    }
  }

  Future<void> openFaqApi() async {
    isLoading = true;
    try {
      String ln = await Preferences.getString(Preferences.keyLanguageCode);

      final apiResponse = await userDetailRepo?.getOpenFAQ(
          FaqResponse.fromJson, ln, kIsWeb ? AppConst.web : AppConst.mobile);
      if (apiResponse != null &&
          apiResponse.data != null &&
          apiResponse.data!.messageKey == AppConst.faqRetrieved) {
        faqResponse = apiResponse.data;
        // Store original list
        allFaqCategories = faqResponse!.data;

        // Initially show all
        filteredFaqCategories = List.from(allFaqCategories);
        setState();
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      Utils.logPrint("Error: $e");
    }
  }

  void onSearchChanged(String value) {
    if (value.trim().isEmpty) {
      filteredFaqCategories = List.from(allFaqCategories);
    } else {
      final lowerQuery = value.toLowerCase();

      filteredFaqCategories = allFaqCategories
          .map((category) {
            final matchedFaqs = category.faqs
                .where((faq) =>
                    category.category.toLowerCase().contains(lowerQuery) ||
                    faq.questionText.toLowerCase().contains(lowerQuery) ||
                    faq.answerText.toLowerCase().contains(lowerQuery))
                .toList();
            if (matchedFaqs.isNotEmpty) {
              return FaqCategory(
                  category: category.category, faqs: matchedFaqs);
            }
            return null;
          })
          .whereType<FaqCategory>()
          .toList();
    }

    setState();
  }

  ticketSupportRedirect() async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting, extra: {
      "url": AppConst.ticketSupport(ln),
      "deeplink": "",
      "openInternalBrowser": true,
      "bottomMessage": S.of(getContext()).you_are_being_to_ticket,
    });
  }

  bookingSupportRedirect() async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting, extra: {
      "url": AppConst.bookingSupport(ln),
      "deeplink": "",
      "openInternalBrowser": true,
      "bottomMessage": S.of(getContext()).you_are_being,
    });
  }

  prepaidSupportRedirect() async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting, extra: {
      "url": AppConst.prepaidSupport(ln),
      "deeplink": "",
      "openInternalBrowser": true,
      "bottomMessage": S.of(getContext()).you_are_being_to_prepaid,
    });
  }

  // If User Not Login Then Navigate To Login Screen
  void navigateToLoginPage() {
    navGo(AppRoutes.login);
  }

  void navigateToHomePage() {
    navGo(AppRoutes.homeNav);
  }
}
