import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../ui/base/base_provider.dart';

class ListCompanionProvider extends BaseProvider {
  final UserDetailRepo userDetailRepo;

  ListCompanionProvider({required this.userDetailRepo});
  CompanionListResponse? companionList;
  MatchResponse? userMatches;
  bool showAddCompanion = false;

  init() async {
    final context = getContext();

    _setLoadingState(true);

    try {
      await _handleCompanionList(context);
      await _handleUserMatches(context);
    } catch (e) {
      Utils.logPrint("Error: $e");
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool loading) {
    isLoading = loading;
    setState();
  }

  Future<void> _handleCompanionList(BuildContext context) async {
    final rep =
        await userDetailRepo.listCompanion(CompanionListResponse.fromJson);

    if (rep.data == null) {
      return;
    }


    if (_isEmptyCompanionList(rep.data!)) {
      _handleEmptyCompanionList(context);
    }

    _handleCompanionDeletion(context);
    companionList = rep.data;
  }

  bool _isEmptyCompanionList(CompanionListResponse data) {
    return data.data?.isEmpty ?? true;
  }

  void _handleEmptyCompanionList(BuildContext context) {
    _setLoadingState(false);
    if (context.mounted) {
      Navigator.of(context).pop(false);
      if (context.mounted) {
        Provider.of<UserGenericProvider>(context, listen: false)
            .updateCompanion(false);
      }
    }
  }

  void _handleCompanionDeletion(BuildContext context) {
    if (context.mounted) {
      final userGenericProvider =
          Provider.of<UserGenericProvider>(context, listen: false);
      if (userGenericProvider.showDelete) {
        userGenericProvider.userCompanionDeleted();
      }
    }
  }

  Future<void> _handleUserMatches(BuildContext context) async {
    final match = await userDetailRepo.getMatches(MatchResponse.fromJson);

    if (match.data == null) {
      return;
    }

    userMatches = match.data;
    _calculateCompanionLimits();
  }

  void _calculateCompanionLimits() {
    if (userMatches?.data == null) {
      showAddCompanion = false;
      return;
    }

    int maxCompanion = 0;
    int companionsAssigned = 0;

    for (final matchData in userMatches!.data) {
      maxCompanion += matchData.maxNoOfCompanions;
      companionsAssigned += matchData.companionsAssigned.length;
    }

    showAddCompanion = maxCompanion > companionsAssigned;
  }

  resendInvite(String companionId) async {
    final context = getContext();

    isLoading = true;
    try {
      FirebaseAnalyticsService.logEvent(
          eventName: "campanionDetails_resendCompanioninvitebutton",
          parameters: {
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "Companion",
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "resendCompanionInvite"
          }
      );
      final rep =
          await userDetailRepo.companionResendEmail((json) => (), companionId);
      if (rep.isSuccess) {
        // success
        if (context.mounted) {
          visaSnackBar(
              context: context,
              title: "${S.of(context).success}!",
              subtitle: S.of(context).companion_invite_has_been_resent,
              showAtBottom: true,
              isNavBar: false);
          Utils.announceMessage(S.of(context).companion_invite_has_been_resent);
        }
      } else {
        if (context.mounted) {
          visaSnackBar(
              context: context,
              type: SnackBarType.failure,
              title: "${S.of(context).error}!",
              subtitle: S.of(context).something_went_wrong,
              showAtBottom: true,
              isNavBar: false);
          Utils.announceMessage(S.of(context).something_went_wrong);
        }
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
    isLoading = false;
  }

  addCompanionButton() async {
    final rep = await navPush(AppRoutes.addCompanion);
    if (rep == true) {
      init();
    }
  }
}
