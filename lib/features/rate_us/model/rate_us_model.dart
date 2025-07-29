import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart'
    show VisaButton, VisaButtonVariant;
import 'package:visaamigo/custom_widgets/visa_dialog.dart'
    show VisaDialog, VisaDialogShowConfig;
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart'
    show SnackBarType, visaSnackBar;
import 'package:visaamigo/features/rate_us/model/rate_us_request_model.dart'
    show RateUsRequest;
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart'
    show UserDetailRepo;
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart' show AppRoutes;
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes, Sizes;
import 'package:visaamigo/utils/utils.dart' show Utils;

import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_const.dart';

class RateUsModel extends BaseProvider {
  final UserDetailRepo userDetailRepo;

  RateUsModel({required this.userDetailRepo});

  final formKey = GlobalKey<FormState>();
  final TextEditingController feedbackController = TextEditingController();
  bool alreadyHaveRating = false;
  int selectedRating = 0; // 0 means no rating selected
  bool showError = false;
  String? errorText;
  List<String> formValid = [];
  int initialRating = 0; // Store the initial rating
  String initialFeedback = ""; // Store the initial feedback
  bool hasChanges = false; // Track if there are changes

  Future<void> init(int? selectedStars) async {
    if (selectedStars != null && selectedStars >= 0 && selectedStars <= 5) {
      selectedRating = selectedStars;
      hasChanges = true;
      setState();
    }
    await fetchRating();
    feedbackController.addListener(checkForChanges);
  }

  Future<void> fetchRating() async {
    try {
      isLoading = true;
      setState();
      final response = await userDetailRepo?.getRatting((json) => json);

      if (response != null &&
          response.isSuccess &&
          response.data != null &&
          response.data!['data'].isNotEmpty) {
        alreadyHaveRating = true;
        // selectedRating = response.data!['data']['rating'] ?? 0;
        // feedbackController.text = response.data!['data']['feedback'] ?? '';

        // // Update initial values after fetching the rating
        // initialRating = selectedRating;
        // initialFeedback = feedbackController.text;
        // checkForChanges(); // Ensure button state is updated
      } else {
        errorText = response!.error ?? 'Failed to fetch rating';
      }
    } catch (e) {
      errorText = 'An error occurred while fetching rating';
      Utils.logPrint("Error fetching rating: $e");
    }
    isLoading = false;

    setState();
  }

  @override
  void dispose() {
    // Dispose of the feedbackController to clean up resources
    feedbackController.dispose();
    super.dispose();
  }

  void checkForChanges() {
    // Check if the current values differ from the initial values
    hasChanges = selectedRating != 0;
    setState();
  }

  void onSelectRating(double rating) {
    selectedRating = rating.toInt();
    checkForChanges(); // Check for changes after updating the rating
    showError = false;
    setState();
  }

  void onFeedbackChanged() {
    checkForChanges(); // Check for changes when feedback is updated
  }

  void onShowError() {
    showError = true;
    setState();
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

  Future<void> submitRating() async {
    if (!isLoading && hasChanges) {
      formValid = ['feedback'];
      showError = true;
      errorText = null;
      setState();

      await Future.delayed(const Duration(milliseconds: 150));
      if (!(formKey.currentState != null && formKey.currentState!.validate()) ||
          selectedRating == 0) {
        return;
      }
      isLoading = true;

      await rateUs();
      isLoading = false;
    } else if (selectedRating == 0) {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      if (context.mounted) {
        visaSnackBar(
            context: context,
            title: S.of(context).error,
            subtitle: S.of(context).please_select_rating,
            type: SnackBarType.failure,
            showAtBottom: true);
      }
    }
  }

  Future<void> rateUs() async {
    final context = getContext();
    try {
      final response = await _submitRatingRequest();
      if (response != null && response.isSuccess) {
        isLoading = false;
        if (selectedRating > 3) {
          if (context.mounted) {
            await _showHighRatingDialog(context);
          }
        } else {
          isLoading = false;
          if (context.mounted) {
            await _showLowRatingDialog(context);
          }
        }
      }
    } catch (e) {
      isLoading = false;
      setState();
      Utils.logPrint("Error: $e");
    }
  }

  Future<dynamic> _submitRatingRequest() async {
    RateUsRequest addCompanion = RateUsRequest(
      rating: selectedRating,
      feedback: feedbackController.text.trim(),
    );
    if (alreadyHaveRating) {
      return await userDetailRepo.updateRating(
          (json) => (), addCompanion.toJson());
    } else {
      return await userDetailRepo.rateUs((json) => (), addCompanion.toJson());
    }
  }

  Future<void> _showHighRatingDialog(BuildContext context) async {
    var dialogResponse = await VisaDialog.show(
      context: context,
      title: S.of(context).tell_us_more,
      message: S.of(context).app_store_prompt,
      config: VisaDialogShowConfig(
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.tweleveWidth,
          vertical: AppSizes.tweentyHeight,
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        barrierDismissible: false,
        showCloseButton: true,
        customTitleColor: VisaColors.primary,
        titleFontSize: Sizes.thirtySixInt.toDouble(),
        subtitleFontSize: Sizes.twelveInt.toDouble(),
        customContent: VisaButton(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          buttonColor: VisaColors.primaryLight,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 6.r),
          text: Theme.of(context).platform == TargetPlatform.android
              ? S.of(context).take_me_to_play_store
              : S.of(context).take_me_to_app_store,
          variant: VisaButtonVariant.primary,
          onPressed: () {
            navPop();
            navPop();
            _handleStoreNavigation(context);
          },
        ),
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
    if (dialogResponse != null || dialogResponse) {
      navPop();
    }
  }

  void _handleStoreNavigation(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      navPush(AppRoutes.redirecting, extra: {
        "url": AppConst.playStoreLink,
        "bottomMessage": S.of(context).redirect_play_store,
        "openInternalBrowser": false
      });
    } else {
      navPush(AppRoutes.redirecting, extra: {
        "url": AppConst.appStoreLink,
        "bottomMessage": S.of(context).redirect_app_store,
        "openInternalBrowser": false
      });
    }
  }

  Future<void> _showLowRatingDialog(BuildContext context) async {
    var dialogResponse = await VisaDialog.show(
      context: context,
      title: S.of(context).thanks_feedback,
      message: "",
      config: VisaDialogShowConfig(
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.tweleveWidth,
          vertical: AppSizes.tweentyHeight,
        ),
        padding: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 15.h,
          bottom: AppSizes.tweentyHeight,
        ),
        barrierDismissible: false,
        showCloseButton: true,
        customTitleColor: VisaColors.primary,
        titleFontSize: Sizes.thirtySixInt.toDouble(),
        subtitleFontSize: Sizes.twelveInt.toDouble(),
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
    Utils.logPrint("dialogResponse ${dialogResponse}");
    if (dialogResponse != null || dialogResponse) {
      navPop();
    }
  }

  Future<bool> rateUs2() async {
    try {
      await fetchRating();

      RateUsRequest addCompanion = RateUsRequest(
          rating: selectedRating, feedback: feedbackController.text.trim());
      dynamic response;
      if (alreadyHaveRating) {
        response = await userDetailRepo.updateRating(
            (json) => (), addCompanion.toJson());
      } else {
        response =
            await userDetailRepo.rateUs((json) => (), addCompanion.toJson());
      }
      if (response != null && response.isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
      return false;
    }
  }
}
