import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../home/model/match_details.dart';
import '../../splash_screen/repo/user_detail_repo.dart';
import '../../wallet/model/wallet_model.dart';

class AiAssistantWelcomeScreenProvider extends BaseProvider {
  UserModel? userModel;
  MatchResponse? userMatches;
  WalletResponse? walletResponse;
  List<String> packageContents = [];
  UserDetailRepo? userDetailRepo;

  Future<void> init({bool isComeFromWelcomeScreen = false}) async {
    // Capture context before async operations
    final context = mContext;

    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);

    // Check if context is still mounted before using it
    if (context.mounted) {
      var provider = Provider.of<UserGenericProvider>(context, listen: false);
      provider.setUserModel(userModel);
      if (isComeFromWelcomeScreen) {
        userDetailRepo = UserDetailRepo(apiClient);
        userMatches = provider.userMatchDetail;
        walletResponse = provider.walletResponses;
        getUserMatchesList();
        getWalletResponseList();
        updateGettingToKnowPreference();
      }
      setState();
    }
  }

  void getUserMatchesList() {
    if (userMatches != null && userMatches!.data.isNotEmpty) {
      for (var match in userMatches!.data) {
        int ticketCount = match.tickets.length;
        String event = match.eventName; // e.g. "Match5"
        String teams = match.matchTeams; // e.g. "TBD1 v TBD2"

        String sentence =
            "$ticketCount ${S.of(mContext).tickets_to} $event, $teams";
        packageContents.add(sentence);
      }
    }
  }

  void getWalletResponseList() {
    if (walletResponse != null && walletResponse!.data.isNotEmpty) {
      for (var wallet in walletResponse!.data) {
        var balance = wallet.voucher.initialBalance;
        String sentence =
            "${getCurrencySymbol(balance.currency)}${balance.amount} ${balance.currency} ${S.of(mContext).travel_credit}";
        packageContents.add(sentence);
      }

      for (var wallet in walletResponse!.data) {
        var balance = wallet.prepaidCard.initialBalance;
        String sentence =
            "${getCurrencySymbol(balance.currency)}${balance.amount} ${balance.currency} ${S.of(mContext).prepaid_card_package}";
        packageContents.add(sentence);
      }
    }
  }

  Future<void> updateGettingToKnowPreference() async {
    userDetailRepo?.updateUserPreferenceKnowYourUser({
      "getting_to_know": ["true"]
    }, (json) => (), false);
  }

  // Navigate to the Home Screen
  Future<void> navigateToHomeScreen() async {
    await Preferences.setBool(Preferences.isGettingToKnowDone, true);
    final val = await Preferences.getBool(Preferences.isGettingToKnowNavigation);
    FirebaseAnalyticsService.logEvent(
      eventName: "gtky_success",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: val ? "profile" : "registration"
      },
    );
    if (val) {
      navPop();
    } else {
      navGo(AppRoutes.homeNav);
    }
  }
}
