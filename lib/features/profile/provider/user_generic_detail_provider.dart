import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/visa_custom_native_dialog.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../home/model/match_details.dart';
import '../../signup/model/user_config_model.dart';
import '../../wallet/model/wallet_model.dart';

class UserGenericProvider extends BaseProvider {
  UserModel? userModel;
  MatchResponse? _userMatchDetail;
  WalletResponse? _walletResponse;
  String matchLimit = "";
  UserConfigModel? _userConfigModel;

  UserConfigModel? get userConfigModel => _userConfigModel;

  set userConfigModel(UserConfigModel? value) {
    _userConfigModel = value;
  }

  bool? isCompanion;
  String? evaIntroNode;
  bool? _is24hrsClockEnable;

  bool get is24hrsClockEnable => _is24hrsClockEnable ?? false;

  set is24hrsClockEnable(bool value) {
    _is24hrsClockEnable = value;
    setState();
  }

  MatchResponse? get userMatchDetail => _userMatchDetail;

  set setEvaIntroNode(String? value) {
    evaIntroNode = value;
    setState();
  }

  updateEvaIntroNode(String value) {
    evaIntroNode = value;
    notifyListeners();
  }

  set userMatchDetail(MatchResponse? value) {
    _userMatchDetail = value;

    updateUserCompanionStatus();
    setState();
  }

  WalletResponse? get walletResponses => _walletResponse;

  set walletResponse(WalletResponse? value) {
    _walletResponse = value;
    setState();
  }

  int readNotificationCount = 0;
  int readTravelCredit = 0;
  bool listCompanion = false;
  bool walletRedeem = false;
  bool showDelete = false;

  changeDelete(bool val) {
    showDelete = val;
    notifyListeners();
  }

  updateTravelCreditVisit() {
    readTravelCredit = readTravelCredit + 1;
    notifyListeners();
  }

  updateWalletRedeem(bool val) {
    walletRedeem = val;
    notifyListeners();
  }

  updateCompanion(bool val) {
    listCompanion = val;
    Preferences.setBool(Preferences.listCompanion, val);
    notifyListeners();
  }

  userCompanionDeleted() async {
    showDelete = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    if (matchLimit.isEmpty) {
      visaSnackBar(
          context: getContext(),
          title: "${S.of(getContext()).success}!",
          subtitle: S.of(getContext()).companion_deleted,
          duration: const Duration(seconds: 2),
          showAtBottom: listCompanion ? true : false);
    } else {
      VisaNativeDialog.show(
        title: S.of(mContext).attention_required,
        context: mContext,
        message: matchLimit.toString(),
        config: VisaDialogConfig(
            positiveButtonText: S.of(mContext).ok,
            barrierDismissible: false,
            closeDialogPositiveClick: true),
      );
      Future.delayed(const Duration(milliseconds: 2000), () {
        matchLimit = "";
        notifyListeners();
      });
    }
    Utils.announceMessage(S.of(getContext()).companion_deleted);
  }

  void updateUserModel() async {
    await Future.delayed(const Duration(milliseconds: 150));
    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);
    setState();
  }

  setUserModel(UserModel? userDetail) {
    userModel = userDetail;

    if (userDetail != null && userDetail.userAnalyticsId.isNotEmpty) {
      FirebaseAnalyticsService.userAnalyticsId = userDetail.userAnalyticsId;
    }
  }

  void markNotificationRead() {
    readNotificationCount = readNotificationCount - 1;

    notifyListeners();

    Utils.logPrint("readNotificationCount ${readNotificationCount}");
  }

  void markNotificationUnRead() {
    readNotificationCount = readNotificationCount + 1;

    notifyListeners();

    Utils.logPrint("readNotificationCount ${readNotificationCount}");
  }

  void updateUserCompanionStatus() async {
    isCompanion = await Preferences.getBool(Preferences.isCompanion);
    // isCompanion = !(isCompanion!);
  }

  void resetPackageDetails() {
    userMatchDetail = null;
    walletResponse = null;
    notifyListeners();
  }
}
