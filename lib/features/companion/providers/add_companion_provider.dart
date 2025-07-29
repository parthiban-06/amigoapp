import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';
import 'package:visaamigo/features/companion/model/add_companion_model.dart';
import 'package:visaamigo/features/companion/model/delete_companion_model.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/companion/screens/delete_companion.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/utils.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../ui/base/base_provider.dart';

class AddCompanionProvider extends BaseProvider {
  final UserDetailRepo userDetailRepo;

  AddCompanionProvider({required this.userDetailRepo});

  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();

  List<Options> matchList = [];
  List<Options> editMatchList = [];
  List<Map<String, dynamic>> formError = [];
  bool iAcknowledge = false;
  bool isDisable = false;
  bool iAgree = false;
  CompanionProfile? userModel;
  final forbiddenCharactersRegex = RegExp(r'[<>{}]');

  bool showError = false;
  bool showIAcknowledgeIAgreeError = false;
  bool showMatchListError = false;
  List<String> formValid = [];
  String? errorText;

  bool isEdit = false;
  MatchResponse? matchResponse;
  var uiElement = "";
  Map<String, Object> analyticsParameters = {};

  void init(CompanionProfile? user) async {
    var eventName = "";
    if (user != null) {
      initEditCompanion(user);
      uiElement = "update";
      eventName = "editCompanion_formStart";
    } else {
      initAddCompanion();
      uiElement = "add";
      eventName = "companionDetails_formstart";
    }

    setCompanionForEvent(eventName);
    analyticsParameters[AnalyticsEventConst.PARAM_NAME_UI_ELEMENT] = uiElement;
  }

  initAddCompanion() async {
    isLoading = true;

    try {
      final match = await userDetailRepo.getMatches(
        MatchResponse.fromJson,
      );

      if (match.data != null) {
        matchResponse = match.data;
        for (int i = 0; i < matchResponse!.data.length; i++) {
          if (matchResponse!.data.elementAt(i).maxNoOfCompanions >
              matchResponse!.data.elementAt(i).companionsAssigned.length) {
            matchList.add(Options(
                optionName:
                    "${matchResponse!.data.elementAt(i).eventName} ${matchResponse!.data.elementAt(i).matchTeams}",
                optionId: matchResponse!.data.elementAt(i).id,
                isSelected: false));
          }
        }
        setState();
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
  }

  initEditCompanion(CompanionProfile user) async {
    isEdit = true;
    userModel = user;
    email.text = user.email;
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    iAcknowledge = true;
    iAgree = true;
    setState();

    isLoading = true;

    try {
      final match = await userDetailRepo.getMatches(
        MatchResponse.fromJson,
      );

      if (match.data != null) {
        matchResponse = match.data;
        for (int i = 0; i < matchResponse!.data.length; i++) {
          if (user.matchIds.contains(matchResponse!.data.elementAt(i).id)) {
            editMatchList.add(Options(
                optionName:
                    "${matchResponse!.data.elementAt(i).eventName} ${matchResponse!.data.elementAt(i).matchTeams}",
                optionId: matchResponse!.data.elementAt(i).id,
                isSelected: true,
                permanentSelected: true));
          }
          if (matchResponse!.data.elementAt(i).maxNoOfCompanions >
              matchResponse!.data.elementAt(i).companionsAssigned.length) {
            matchList.add(Options(
                optionName:
                    "${matchResponse!.data.elementAt(i).eventName} ${matchResponse!.data.elementAt(i).matchTeams}",
                optionId: matchResponse!.data.elementAt(i).id,
                isSelected: false));
          }
        }
        setState();
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
  }

  void addToFormError(Map<String, dynamic> error) {
    bool exists = formError.any((map) =>
        map.length == error.length &&
        map.entries.every((entry) => error[entry.key] == entry.value));
    if (!exists) {
      formError.add(error);
    }
  }

  onShowError() {
    showError = true;
    setState();
  }

  changeMatchList(int index) {
    if (editMatchList.isNotEmpty) {
      index = index - editMatchList.length;
    }
    bool isSelected = matchList.elementAt(index).isSelected =
        !(matchList.elementAt(index).isSelected ?? false);
    String label = isSelected
        ? S.of(getContext()).selected
        : S.of(getContext()).unselected;
    Utils.announceMessage(label);
    showMatchListError = false;
    checkDisable();
    setState();
  }

  onChangeAcknowledge() {
    if (isEdit) return;
    FocusManager.instance.primaryFocus?.unfocus();
    iAcknowledge = !iAcknowledge;
    setCompanionForEvent("companionDetails_checkbox1click",
        uiElements: "checkboxclicked1");
    showIAcknowledgeIAgreeError = false;
    String label = iAcknowledge
        ? "${S.of(getContext()).check_box}, ${S.of(getContext()).checked}"
        : "${S.of(getContext()).check_box}, ${S.of(getContext()).unchecked}";
    Utils.announceMessage(label);
    setState();
    checkDisable();
  }

  onChangeAgree() {
    if (isEdit) return;
    FocusManager.instance.primaryFocus?.unfocus();
    iAgree = !iAgree;
    showIAcknowledgeIAgreeError = false;
    String label = iAgree
        ? "${S.of(getContext()).check_box}, ${S.of(getContext()).checked}"
        : "${S.of(getContext()).check_box}, ${S.of(getContext()).unchecked}";
    Utils.announceMessage(label);
    setState();
    setCompanionForEvent("companionDetails_checkbox2click",
        uiElements: "checkboxclicked2");
    checkDisable();
  }

  validStateChanges(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    formError.clear();
    errorText = null;
    showError = true;
    checkDisable();
    setState();
  }

  checkDisable() {
    if (_isEmailValid() && _areNamesValid() && _areCheckboxesValid()) {
      if (isEdit) {
        _enableForm();
        return;
      } else if (_hasSelectedMatches()) {
        _enableForm();
        return;
      }
    }
    _disableForm();
  }

  bool _isEmailValid() {
    return Validation.emailValid.hasMatch(email.text) && errorText == null;
  }

  bool _areNamesValid() {
    return firstName.text.trim().length > 1 && lastName.text.trim().length > 1;
  }

  bool _areCheckboxesValid() {
    return iAcknowledge == true && iAgree == true;
  }

  bool _hasSelectedMatches() {
    return matchList.where((match) => match.isSelected == true).isNotEmpty;
  }

  void _enableForm() {
    isDisable = true;
    setState();
  }

  void _disableForm() {
    isDisable = false;
    setState();
  }

  validate(String valid) {
    if (!formValid.contains(valid)) {
      formValid.add(valid);
    }
    _formError(!isEdit);
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
    Utils.announceMessage(error);
    setState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  addCompanion() async {
    _setupFormValidation();
    await Future.delayed(const Duration(milliseconds: 150));

    if (!_validateForm()) {
      _formError(!isEdit);
      return;
    }

    final optionIds = _getSelectedOptionIds();

    if (!_validateFormRequirements(optionIds)) {
      return;
    }

    if (_shouldSkipProcessing()) {
      return;
    }

    await _processCompanionRequest(optionIds);
  }

  void _setupFormValidation() {
    formValid = [
      S.of(getContext()).login_username,
      S.of(getContext()).first_name,
      S.of(getContext()).last_name
    ];
    showError = true;
    errorText = null;
    setState();
  }

  bool _validateForm() {
    return formKey.currentState != null && formKey.currentState!.validate();
  }

  /// Form error
  void _formError(bool isForUpdate) {
    Future.delayed(const Duration(milliseconds: 350), () {
      String errorField = formError
          .map((map) => map['label'])
          .where((name) => name != null)
          .join(', ');
      String errorMessage = formError
          .map((map) => map['error'])
          .where((name) => name != null)
          .join(', ');
      FirebaseAnalyticsService.logEvent(
        eventName: !isForUpdate
            ? "editCompanion_formError"
            : "companionDetails_formerror",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
              !isForUpdate ? "edit_travel_companion" : "add_travel_companion",
          AnalyticsEventConst.FORM_NAME:
              !isForUpdate ? "edit_travel_companion" : "add_travel_companion",
          AnalyticsEventConst.FORM_ID:
              !isForUpdate ? "edit_travel_companion" : "add_travel_companion",
          "error_field": errorField,
          "error_type": errorMessage,
          "error_message": errorMessage,
        },
      );
      Utils.logPrint("Errors: $formError");
    });
  }

  List<String> _getSelectedOptionIds() {
    return matchList
        .where((option) => option.isSelected == true && option.optionId != null)
        .map((option) => option.optionId!)
        .toList();
  }

  bool _validateFormRequirements(List<String> optionIds) {
    if (isEdit == false && isDisable == false && optionIds.isEmpty) {
      showMatchListError = true;
      Utils.announceMessage(S.of(getContext()).match_list_error);
      setState();
      return false;
    }

    if (isEdit == false &&
        isDisable == false &&
        (iAcknowledge == false || iAgree == false)) {
      showIAcknowledgeIAgreeError = true;
      setState();
      return false;
    }

    return true;
  }

  bool _shouldSkipProcessing() {
    return isEdit == true && isDisable == false;
  }

  Future<void> _processCompanionRequest(List<String> optionIds) async {
    _setLoadingState(true);

    try {
      if (isEdit == false) {
        await _addNewCompanion(optionIds);
      } else {
        await _editExistingCompanion(optionIds);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool loading) {
    isLoading = loading;
    setState();
  }

  Future<void> _addNewCompanion(List<String> optionIds) async {
    final addCompanion = _createCompanionModel(optionIds);
    final rep =
        await userDetailRepo.addCompanion((json) => (), addCompanion.toJson());

    if (_isSuccessfulResponse(rep)) {
      await _handleSuccessfulAdd();
    } else {
      _handleAddError(rep);
    }
  }

  Future<void> _editExistingCompanion(List<String> optionIds) async {
    final allOptionIds = _getAllOptionIds(optionIds);
    final addCompanion = _createCompanionModel(optionIds);

    final rep = await userDetailRepo?.editCompanion(
        (json) => (), addCompanion.toJsonEdit(), userModel!.id);

    if (rep != null && rep.isSuccess) {
      await _handleSuccessfulEdit();
    } else {
      _handleEditError();
    }
  }

  AddCompanion _createCompanionModel(List<String> matchIds) {
    return AddCompanion(
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      email: email.text.trim(),
      matchIds: matchIds,
    );
  }

  List<String> _getAllOptionIds(List<String> optionIds) {
    final editOptionIds = editMatchList
        .where((option) => option.isSelected == true && option.optionId != null)
        .map((option) => option.optionId!)
        .toList();
    editOptionIds.addAll(optionIds);
    return editOptionIds;
  }

  bool _isSuccessfulResponse(dynamic rep) {
    return rep.isSuccess &&
        rep.messageKey != AppConst.primaryUser &&
        rep.messageKey != AppConst.alreadyAdded;
  }

  Future<void> _handleSuccessfulAdd() async {
    final context = getContext();

    setCompanionForEvent("companionDetails_formcomplete");

    if (context.mounted &&
        Provider.of<UserGenericProvider>(context, listen: false)
            .listCompanion) {
      _showSuccessMessageAndPop(context);
    } else {
      _showSuccessMessageAndNavigate(context);
    }
  }

  Future<void> _handleSuccessfulEdit() async {
    final context = getContext();

    setCompanionForEvent("editCompanion_formComplete");
    _showEditSuccessMessage(context);
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _showSuccessMessageAndPop(BuildContext context) {
    _showSuccessSnackBar(context, S.of(context).companion_added);
    Utils.announceMessage(S.of(context).companion_added);
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _showSuccessMessageAndNavigate(BuildContext context) {
    _showSuccessSnackBar(context, S.of(context).companion_added);
    Utils.announceMessage(S.of(context).companion_added);
    if (context.mounted) {
      Provider.of<UserGenericProvider>(context, listen: false)
          .updateCompanion(true);
    }
    navPushReplace(AppRoutes.listCompanion);
  }

  void _showEditSuccessMessage(BuildContext context) {
    _showSuccessSnackBar(context, S.of(context).companion_edit_completed);
    Utils.announceMessage(S.of(context).companion_edit_completed);
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      visaSnackBar(
        context: context,
        title: "${S.of(context).success}!",
        subtitle: message,
        showAtBottom: true,
        isNavBar: false,
      );
    }
  }

  void _handleAddError(dynamic rep) {
    final context = getContext();

    if (rep.messageKey == AppConst.primaryUser) {
      _showErrorSnackBar(
          context, S.of(context).primary_user_cannot_be_a_companion);
    } else if (rep.messageKey == AppConst.alreadyAdded) {
      _showErrorSnackBar(context, S.of(context).already_added);
    } else if (rep.messageKey == AppConst.maxAttemptsExceeded) {
      _showErrorSnackBar(
          context, S.of(context).you_reached_the_companion_change);
    } else if (rep.messageKey == AppConst.self_companion_not_allowed) {
      _showErrorSnackBar(context, S.of(context).self_companion_not_allowed);
    } else {
      _showErrorSnackBar(context, S.of(context).something_went_wrong);
    }
  }

  void _handleEditError() {
    final context = getContext();

    _showErrorSnackBar(context, S.of(context).something_went_wrong);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      visaSnackBar(
        context: context,
        type: SnackBarType.failure,
        title: "${S.of(context).error}!",
        subtitle: message,
        duration: const Duration(seconds: 2),
        showAtBottom: true,
        isNavBar: false,
      );
      //Utils.announceMessage(message);
    }
  }

  void _handleError(dynamic error) {
    Utils.logPrint("Error: $error");
  }

  onDelete() {
    final context = getContext();

    FirebaseAnalyticsService.logEvent(
        eventName: "editCompanion_deleteCompanionbutton",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "delete_companion_button",
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.editCompanion,
        });

    if (context.mounted) {
      Utils.deleteCompanionPopup(
          context: context, child: DeleteCompanion(companionId: userModel!.id));
    }
  }

  deleteCompanion(String companionId) async {
    final context = getContext();

    isLoading = true;
    setState();
    final rep = await userDetailRepo.deleteCompanion(
        CompanionDeleteResponse.fromJson, companionId);
    String matchLimit = "";
    if (rep.isSuccess) {
      final matchRep = Provider.of<UserGenericProvider>(context, listen: false)
          .userMatchDetail;
      if (rep.data != null && matchRep != null && matchRep.data.isNotEmpty) {
        for (int i = 0; i < rep.data!.data.limit.length; i++) {
          if (rep.data!.data.limit.elementAt(i).limitLeft == 0) {
            final matchData = matchRep.data.firstWhere(
                (e) => e.id == rep.data!.data.limit.elementAt(i).matchId);
            matchLimit = matchLimit +
                "• ${matchData.eventName} ${matchData.matchTeams} - ${S.of(context).limit_exhausted}\n\n";
            continue;
          }
          if (rep.data!.data.limit.elementAt(i).limitLeft <= 3) {
            final matchData = matchRep.data.firstWhere(
                (e) => e.id == rep.data!.data.limit.elementAt(i).matchId);
            matchLimit = matchLimit +
                "• ${matchData.eventName} ${matchData.matchTeams} - ${rep.data!.data.limit.elementAt(i).limitLeft.toString()} ${rep.data!.data.limit.elementAt(i).limitLeft == 1 ? S.of(context).attempt_left : S.of(context).attempts_left}\n\n";
          }
        }
      }
      if (matchLimit.isNotEmpty) {
        matchLimit = removeTrailingNewlines(matchLimit);
        matchLimit = "${S.of(context).you_are_nearing_your}\n\n" + matchLimit;
        Provider.of<UserGenericProvider>(context, listen: false).matchLimit =
            matchLimit;
      }
      isLoading = false;
      setState();
      if (context.mounted) {
        Navigator.of(context).pop(true);
        Navigator.of(context).pop(true);
        Provider.of<UserGenericProvider>(context, listen: false)
            .changeDelete(true);
      }
    } else {
      isLoading = false;
      setState();
      if (context.mounted) {
        Navigator.of(context).pop();
        visaSnackBar(
            context: context,
            type: SnackBarType.failure,
            title: "${S.of(context).error}!",
            subtitle: S.of(context).something_went_wrong,
            showAtBottom: true,
            isNavBar: false);
        // Utils.announceMessage(S.of(context).something_went_wrong);
      }
    }

    isLoading = false;
    setState();
  }

  String removeTrailingNewlines(String input) {
    while (input.endsWith('\n')) {
      input = input.substring(0, input.length - 1);
    }
    return input;
  }

  void setCompanionForEvent(String eventName,
      {String? uiElements, Map<String, Object>? options}) {
    FirebaseAnalyticsService.logEvent(
      eventName: eventName,
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "Companion",
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: uiElements ?? uiElement,
        AnalyticsEventConst.FORM_NAME:
            isEdit ? "edit_travel_companion" : "add_travel_companion",
        AnalyticsEventConst.FORM_ID:
            isEdit ? "edit_travel_companion" : "add_travel_companion",
      }..addAll(options ?? {}),
    );
  }
}
