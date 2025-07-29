import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_animated_expand_collapse_widget.dart';
import 'package:visaamigo/features/itinerary/widgets/itinerary_popup.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../analytics/firebase_analytics_service.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_appbar_actions.dart';
import '../../../../../custom_widgets/visa_button.dart';
import '../../../../../custom_widgets/visa_cache_network_image_widget.dart';
import '../../../../../custom_widgets/visa_no_image_widget.dart';
import '../../../../../custom_widgets/visa_rich_text.dart';
import '../../../../../custom_widgets/visa_svg_icon.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../models/ai_search_places_model.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';

class PlacesWidget extends StatelessWidget {
  final Place places;
  final ChatProvider chatProvider;
  final Message message;
  final int index;
  final bool isBottomSheet;

  const PlacesWidget({
    super.key,
    required this.places,
    required this.chatProvider,
    required this.message,
    required this.index,
    required this.isBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: isBottomSheet ? Sizes.twelveInt.h : Sizes.twentyFourInt.h),
      child: isBottomSheet
          ? SingleChildScrollView(
              child: _buildColumnContent(context),
            )
          : _buildColumnContent(context),
    );
  }

  _buildColumnContent(BuildContext context) {
    final s = S.of(context);

    _logAnalyticsEvent();

    return InkWell(
      onTap: () => _handleTap(context),
      child: Semantics(
        label: '${s.view_details_about}: ${places.displayName}',
        button: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isBottomSheet) _buildCloseButton(context, s),
            _buildPlaceImage(context, s),
            VisaSizeBox(height: Sizes.sixteenInt.toDouble()),
            _buildPlaceTitle(context, s),
            _buildDivider(),
            _buildExpandedContent(context, s),
            if (isBottomSheet) AppSizes.smallVS,
          ],
        ),
      ),
    );
  }

  /// Logs analytics event for bottom sheet
  void _logAnalyticsEvent() {
    if (isBottomSheet) {
      FirebaseAnalyticsService.logEvent(
        eventName: "evaaddtoitinerary_impressionseen",
          parameters: {
            AnalyticsEventConst.PARAM_NAME_TILE_NAME: FirebaseAnalyticsService.firstEvaSection,
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "add_to_Itinerary",
          }
      );
    }
  }

  /// Handles tap on the place widget
  void _handleTap(BuildContext context) {
    if (!isBottomSheet) {
      Utils.hideKeyboard(context);
      chatProvider.cancelEditChat();
      _showBottomSheet(context);
    }
  }

  /// Shows the bottom sheet with place details
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      useRootNavigator: true,
      enableDrag: true,
      backgroundColor: Colors.white,
      showDragHandle: false,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).r,
          child: PlacesWidget(
            chatProvider: chatProvider,
            places: places,
            message: message,
            index: index,
            isBottomSheet: true,
          ),
        );
      },
    );
  }

  /// Builds the close button for bottom sheet
  Widget _buildCloseButton(BuildContext context, S s) {
    return Row(
      children: [
        const Spacer(),
        VisaAppBarActions(
          onPressed: () => Navigator.of(context).pop(),
          visaTextStyle: VisaTextStyle.bodyMedium,
          visaTextTheme: VisaTextTheme.textColorBlack,
          isIconShow: true,
          isTextShow: true,
          text: s.close.toUpperCase(),
          icons: Icons.close,
          iconColor: VisaColors.black,
          iconSize: AppSizes.sixteenRadius,
          letterSpacing: Sizes.two,
          customColor: VisaColors.black,
          padding: EdgeInsets.only(right: AppSizes.zero),
          isComeFromAppBar: false,
        ),
      ],
    );
  }

  /// Builds the place image section
  Widget _buildPlaceImage(BuildContext context, S s) {
    return Semantics(
      container: true,
      label: _getImageSemanticsLabel(s),
      image: true,
      child: Container(
        width: context.screenWidth,
        height: _getImageHeight(),
        decoration: _getImageDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.ten),
          child: _buildImageContent(),
        ),
      ),
    );
  }

  /// Gets the image semantics label
  String _getImageSemanticsLabel(S s) {
    return _hasPhotos()
        ? '${s.image_of} ${places.displayName}'
        : '${s.no_image_available_for}: ${places.displayName}';
  }

  /// Checks if place has photos
  bool _hasPhotos() {
    return places.photos != null && places.photos!.isNotEmpty;
  }

  /// Gets the image height based on bottom sheet state
  double _getImageHeight() {
    return isBottomSheet ? 150.h : 101.h;
  }

  /// Gets the image decoration
  ShapeDecoration _getImageDecoration() {
    return ShapeDecoration(
      color: _hasPhotos()
          ? VisaColors.hotelCardBgColor
          : VisaColors.hotelCardEmptyBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.ten),
      ),
    );
  }

  /// Builds the image content
  Widget _buildImageContent() {
    if (!_hasPhotos()) {
      return const VisaNoImageWidget();
    }
    return VisaCacheNetworkImageWidget(
      imageUrl: places.photos![0],
      fit: BoxFit.cover,
    );
  }

  /// Builds the place title section
  Widget _buildPlaceTitle(BuildContext context, S s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.zeroInt.toDouble(),
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_buildPlaceName(s) != null) _buildPlaceName(s)!,
              VisaSizeBox(height: Sizes.eightInt.toDouble()),
              _buildPlaceType(s),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the place name
  Widget? _buildPlaceName(S s) {
    if (places.displayName.isEmpty) return null;

    return VisaTextView(
      semanticsLabel: '${s.place_name}: ${places.displayName}',
      text: places.displayName,
      colorTheme: VisaTextTheme.customTextColor,
      style: VisaTextStyle.custom,
      customColor: VisaColors.chatTextColor,
      fontSize: AppSizes.fontMedium,
      fontFamily: VisaFontWeight.bold,
      overflow: TextOverflow.ellipsis,
      lineHeight: 1.17,
      maxLines: isBottomSheet ? 5 : 1,
      textAlign: TextAlign.start,
    );
  }

  /// Builds the place type section
  Widget _buildPlaceType(S s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_buildPrimaryType(s) != null) _buildPrimaryType(s)!,
        if (_buildSeeMoreButton(s) != null) _buildSeeMoreButton(s)!,
      ],
    );
  }

  /// Builds the primary type text
  Widget? _buildPrimaryType(S s) {
    if (places.primaryType.isEmpty) return const SizedBox.shrink();

    return Flexible(
      child: VisaTextView(
        semanticsLabel: '${s.primary_type}: ${places.primaryType}',
        text: places.primaryType,
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.chatTextColor,
        fontSize: AppSizes.fontTwelve,
        textAlign: TextAlign.start,
        fontFamily: VisaFontWeight.regular,
        overflow: !isBottomSheet ? TextOverflow.ellipsis : TextOverflow.visible,
        lineHeight: 1.33,
        maxLines: !isBottomSheet ? 1 : null,
      ),
    );
  }

  /// Builds the see more button
  Widget? _buildSeeMoreButton(S s) {
    if (isBottomSheet) return const SizedBox.shrink();

    return Semantics(
      label: s.see_more,
      button: true,
      container: true,
      enabled: true,
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: VisaTextView(
          semantics: false,
          text: s.see_more,
          colorTheme: VisaTextTheme.customTextColor,
          style: VisaTextStyle.link,
          customColor: VisaColors.primary,
          fontSize: AppSizes.fontTwelve,
          fontFamily: VisaFontWeight.semibold,
          overflow: TextOverflow.visible,
          lineHeight: 1.33,
        ),
      ),
    );
  }

  /// Builds the divider
  Widget _buildDivider() {
    return Column(
      children: [
        VisaSizeBox(height: Sizes.twelveInt.toDouble()),
        const Divider(
          color: VisaColors.dividerColor,
          thickness: 1.0,
          height: 0,
        ),
      ],
    );
  }

  /// Builds the expanded content section
  Widget _buildExpandedContent(BuildContext context, S s) {
    return AiAssistantAnimatedExpandCollapseWidget(
      isExpanded: isBottomSheet,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_buildEditorialSummary(s) != null) _buildEditorialSummary(s)!,
          VisaSizeBox(height: Sizes.eightInt.toDouble()),
          _buildRatingAndStatus(s),
          VisaSizeBox(height: Sizes.eightInt.toDouble()),
          _buildAddress(s),
          VisaSizeBox(height: Sizes.eightInt.toDouble()),
          _buildOpenInMapsButton(s),
          VisaSizeBox(height: Sizes.twentyFourInt.toDouble()),
          _buildAddToItineraryButton(context, s),
        ],
      ),
    );
  }

  /// Builds the editorial summary section
  Widget? _buildEditorialSummary(S s) {
    if (!_hasEditorialSummary()) return null;

    return Column(
      children: [
        VisaSizeBox(height: Sizes.sixteenInt.toDouble()),
        _buildEditorialSummaryText(s),
      ],
    );
  }

  /// Checks if editorial summary exists
  bool _hasEditorialSummary() {
    return places.editorialSummary!.text!.isNotEmpty;
  }

  /// Builds the editorial summary text
  Widget _buildEditorialSummaryText(S s) {
    return VisaTextView(
      semanticsLabel:
          '${s.editorial_summary}: ${places.editorialSummary!.text!}',
      text: places.editorialSummary!.text!,
      colorTheme: VisaTextTheme.customTextColor,
      style: VisaTextStyle.custom,
      customColor: VisaColors.black,
      fontSize: AppSizes.fontfourteen,
      fontFamily: VisaFontWeight.regular,
      overflow: TextOverflow.visible,
      lineHeight: 1.29,
      textAlign: TextAlign.start,
    );
  }

  /// Builds the rating and status section
  Widget _buildRatingAndStatus(S s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_buildRatingText(s) != null) _buildRatingText(s)!,
        if (_hasRating()) VisaSizeBox(width: AppSizes.twoInt.toDouble()),
        _buildStarIcon(),
        VisaSizeBox(width: AppSizes.twoInt.toDouble()),
        _buildStatusText(s),
      ],
    );
  }

  /// Checks if place has rating
  bool _hasRating() {
    return places.rating.toString().isNotEmpty;
  }

  /// Builds the rating text
  Widget? _buildRatingText(S s) {
    if (!_hasRating()) return null;

    return VisaTextView(
      semanticsLabel: "${s.rating}: ${places.rating.toString()}",
      text: places.rating.toString(),
      colorTheme: VisaTextTheme.customTextColor,
      style: VisaTextStyle.custom,
      customColor: VisaColors.black,
      fontSize: AppSizes.fontTwelve,
      fontFamily: VisaFontWeight.semibold,
      overflow: TextOverflow.visible,
      lineHeight: 1.33,
      textAlign: TextAlign.start,
    );
  }

  /// Builds the star icon
  Widget _buildStarIcon() {
    return VisaSvgIcon(
      height: AppSizes.tweleveHeight,
      width: AppSizes.tweleveWidth,
      assetPath: Assets.iconsStar,
      color: VisaColors.starYellowColor,
    );
  }

  /// Builds the status text
  Widget _buildStatusText(S s) {
    return Expanded(
      child: VisaRichText(
        textSpans: _buildStatusTextSpans(s),
      ),
    );
  }

  /// Builds the status text spans
  List<VisaTextSpan> _buildStatusTextSpans(S s) {
    return [
      VisaTextSpan(
        text: '•',
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.black,
        fontSize: AppSizes.fontTwelve,
        fontFamily: VisaFontWeight.regular,
        lineHeight: 1.33,
      ),
      VisaTextSpan(
        text: ' ${places.openNow ? s.open_now : s.closed} ',
        style: VisaTextStyle.custom,
        fontSize: AppSizes.fontTwelve,
        lineHeight: 1.33,
        fontFamily: VisaFontWeight.semibold,
        colorTheme: VisaTextTheme.customTextColor,
        customColor: VisaColors.black,
      ),
      if (places.openNow)
        VisaTextSpan(
          text: '• ${places.timings}',
          colorTheme: VisaTextTheme.customTextColor,
          style: VisaTextStyle.custom,
          customColor: VisaColors.black,
          fontSize: AppSizes.fontTwelve,
          fontFamily: VisaFontWeight.regular,
          lineHeight: 1.33,
        ),
    ];
  }

  /// Builds the address section
  Widget _buildAddress(S s) {
    return VisaTextView(
      semanticsLabel: '${s.address}: ${places.formattedAddress.trim()}',
      text: places.formattedAddress.trim(),
      colorTheme: VisaTextTheme.customTextColor,
      style: VisaTextStyle.custom,
      customColor: VisaColors.black,
      fontSize: AppSizes.fontTwelve,
      fontFamily: VisaFontWeight.regular,
      overflow: TextOverflow.visible,
      lineHeight: 1.30,
      textAlign: TextAlign.start,
    );
  }

  /// Builds the open in maps button
  Widget _buildOpenInMapsButton(S s) {
    return InkWell(
      onTap: () => _handleOpenInMaps(),
      child: Semantics(
        label: '${s.open_in_maps} ${s.for_text} ${places.displayName}',
        button: true,
        child: VisaTextView(
          semantics: false,
          text: s.open_in_maps,
          colorTheme: VisaTextTheme.customTextColor,
          style: VisaTextStyle.link,
          customColor: VisaColors.primary,
          fontSize: AppSizes.fontfourteen,
          fontFamily: VisaFontWeight.semibold,
          overflow: TextOverflow.visible,
          lineHeight: (18 / 14).toDouble(),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  /// Handles open in maps button tap
  void _handleOpenInMaps() {
    Utils.logPrint("places ${places.displayName} ${places.location?.toJson()}");
    chatProvider.navigateToRedirectingScreen(places.googleMapsUri);
  }

  /// Builds the add to itinerary button
  Widget _buildAddToItineraryButton(BuildContext context, S s) {
    return VisaButton(
      text: s.add_to_itinerary,
      onPressed: () => _handleAddToItinerary(context),
      fontWeight: VisaFontWeight.medium,
      variant: VisaButtonVariant.primary,
      lineHeight: 1.39,
    );
  }

  /// Handles add to itinerary button tap
  void _handleAddToItinerary(BuildContext context) {
    FirebaseAnalyticsService.logEvent(
      eventName: "evaaddtoitinerary_impressionclicked",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_TILE_NAME: FirebaseAnalyticsService.firstEvaSection,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "add_to_Itinerary",
      }
    );
    Utils.visaItineraryPopup(
      context: context,
      child: ItineraryPopup(
        place: _getItineraryPlaceText(),
      ),
    );
  }

  /// Gets the itinerary place text
  String _getItineraryPlaceText() {
    final displayName = places.displayName.isNotEmpty ? places.displayName : "";
    return "$displayName, ${places.formattedAddress.trim()}";
  }
}
