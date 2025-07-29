import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_items_model.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_animated_expand_collapse_widget.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/string_casing_extention.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_appbar_actions.dart';
import '../../../../../custom_widgets/visa_button.dart';
import '../../../../../custom_widgets/visa_cache_network_image_widget.dart';
import '../../../../../custom_widgets/visa_no_image_widget.dart';
import '../../../../../custom_widgets/visa_rich_text.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/date_util.dart';
import '../../../models/ai_chat_hotels_model.dart';
import '../../../providers/ai_chat_provider.dart';

class HotelsWidget extends StatelessWidget {
  final Hotels hotels;
  final ChatProvider chatProvider;
  final int index;
  final bool isBottomSheet;
  final String checkIn;
  final String checkOut;
  final Guests guests;

  const HotelsWidget({
    super.key,
    required this.hotels,
    required this.chatProvider,
    required this.index,
    required this.isBottomSheet,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
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

    return InkWell(
      onTap: () => _handleTap(context),
      child: Semantics(
        label: '${s.view_details_about}: ${hotels.name}',
        button: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isBottomSheet) _buildCloseButton(context, s),
            _buildHotelImage(context, s),
            VisaSizeBox(height: Sizes.sixteenInt.toDouble()),
            _buildHotelTitle(context, s),
            _buildDivider(),
            _buildExpandedContent(context, s),
            if (isBottomSheet) AppSizes.smallVS,
          ],
        ),
      ),
    );
  }

  /// Handles tap on the hotel widget
  void _handleTap(BuildContext context) {
    Utils.hideKeyboard(context);
    if (!isBottomSheet) {
      chatProvider.cancelEditChat();
      _showBottomSheet(context);
    }
  }

  /// Shows the bottom sheet with hotel details
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
          child: HotelsWidget(
            chatProvider: chatProvider,
            hotels: hotels,
            index: index,
            isBottomSheet: true,
            checkIn: checkIn,
            checkOut: checkOut,
            guests: guests,
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

  /// Builds the hotel image section
  Widget _buildHotelImage(BuildContext context, S s) {
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
        ? '${s.image_of} ${hotels.name}'
        : '${s.no_image_available_for}: ${hotels.name}';
  }

  /// Checks if hotel has photos
  bool _hasPhotos() {
    return hotels.photos != null && hotels.photos!.isNotEmpty;
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
      imageUrl: hotels.photos![0].url!.standard!,
      fit: BoxFit.cover,
    );
  }

  /// Builds the hotel title section
  Widget _buildHotelTitle(BuildContext context, S s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.zeroInt.toDouble(),
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_buildHotelName(s) != null) _buildHotelName(s)!,
              VisaSizeBox(height: Sizes.eightInt.toDouble()),
              _buildHotelAddress(s),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the hotel name
  Widget? _buildHotelName(S s) {
    if (hotels.name!.isEmpty) return null;

    return VisaTextView(
      semanticsLabel: '${s.hotel_name}: ${hotels.name!}',
      text: hotels.name!,
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

  /// Builds the hotel address section
  Widget _buildHotelAddress(S s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_buildAddressText(s) != null) _buildAddressText(s)!,
        if (_buildSeeMoreButton(s) != null) _buildSeeMoreButton(s)!,
      ],
    );
  }

  /// Builds the address text
  Widget? _buildAddressText(S s) {
    if (hotels.location!.address!.isEmpty) return const SizedBox.shrink();

    return Flexible(
      child: VisaTextView(
        semanticsLabel: '${s.address}: ${hotels.location!.address}',
        text: '${hotels.location!.address}',
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.chatTextColor,
        fontSize: AppSizes.fontTwelve,
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
          if (_buildPriceSection(s) != null) _buildPriceSection(s)!,
          VisaSizeBox(height: Sizes.eightInt.toDouble()),
          _buildRatingSection(s),
          VisaSizeBox(height: Sizes.eightInt.toDouble()),
          _buildFullAddress(s),
          VisaSizeBox(height: Sizes.twentyFourInt.toDouble()),
          _buildBookingButton(s),
        ],
      ),
    );
  }

  /// Builds the price section
  Widget? _buildPriceSection(S s) {
    if (!_shouldShowPrice()) return null;

    return Column(
      children: [
        VisaSizeBox(height: Sizes.sixteenInt.toDouble()),
        _buildPriceWidget(s),
      ],
    );
  }

  /// Checks if price should be shown
  bool _shouldShowPrice() {
    return hotels.price!.total.toString().isNotEmpty &&
        hotels.price!.total != 0.0;
  }

  /// Builds the price widget
  Widget _buildPriceWidget(S s) {
    return Semantics(
      enabled: true,
      container: true,
      label: _getPriceSemanticsLabel(s),
      child: Row(
        children: [
          _buildPriceLabel(s),
          _buildPriceValue(),
        ],
      ),
    );
  }

  /// Gets the price semantics label
  String _getPriceSemanticsLabel(S s) {
    return '${s.price_for} ${guests.numberOfAdults} ${s.adults}, ${DateUtil.calculateNights(checkIn, checkOut) ?? ''} ${s.night}: ${getCurrencySymbol(hotels.currency!)}${hotels.price!.total}';
  }

  /// Builds the price label
  Widget _buildPriceLabel(S s) {
    return Flexible(
      child: VisaTextView(
        text:
            '${s.price_for} ${guests.numberOfAdults} ${s.adults}, ${DateUtil.calculateNights(checkIn, checkOut) ?? ''} ${s.night}: ',
        semantics: false,
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.black,
        fontSize: AppSizes.fontfourteen,
        fontFamily: VisaFontWeight.regular,
        overflow: TextOverflow.visible,
        lineHeight: 1.29,
        textAlign: TextAlign.start,
      ),
    );
  }

  /// Builds the price value
  Widget _buildPriceValue() {
    return Flexible(
      child: VisaTextView(
        text: "${getCurrencySymbol(hotels.currency!)}${hotels.price!.total}",
        semantics: false,
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.black,
        fontSize: AppSizes.fontfourteen,
        fontFamily: VisaFontWeight.bold,
        overflow: TextOverflow.visible,
        lineHeight: 1.29,
        textAlign: TextAlign.start,
      ),
    );
  }

  /// Builds the rating section
  Widget _buildRatingSection(S s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_buildRatingContainer(s) != null) _buildRatingContainer(s)!,
        if (_hasRating()) VisaSizeBox(width: AppSizes.twoInt.toDouble()),
        _buildRatingText(s),
      ],
    );
  }

  /// Checks if hotel has rating
  bool _hasRating() {
    return hotels.rating.toString().isNotEmpty;
  }

  /// Builds the rating container
  Widget? _buildRatingContainer(S s) {
    if (!_hasRating()) return null;

    return Container(
      width: 22,
      height: 22,
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: VisaColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.22),
            topRight: Radius.circular(5.22),
            bottomRight: Radius.circular(5.22),
          ),
        ),
      ),
      child: VisaTextView(
        semanticsLabel:
            '${s.rating}: ${hotels.rating!.reviewScore!.toString()}',
        text: hotels.rating!.reviewScore!.toString(),
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.ratingTextColor,
        fontSize: 9.39.sp,
        fontFamily: VisaFontWeight.semibold,
        overflow: TextOverflow.visible,
        lineHeight: 1.78,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds the rating text
  Widget _buildRatingText(S s) {
    return Expanded(
      child: VisaRichText(
        textSpans: _buildRatingTextSpans(s),
      ),
    );
  }

  /// Builds the rating text spans
  List<VisaTextSpan> _buildRatingTextSpans(S s) {
    final spans = <VisaTextSpan>[];

    if (hotels.rating!.reviewText!.isNotEmpty) {
      spans.add(VisaTextSpan(
        text: " ${hotels.rating!.reviewText!.capitalizeFirst()}",
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.black,
        fontSize: AppSizes.fontTwelve,
        fontFamily: VisaFontWeight.regular,
        lineHeight: 1.30,
      ));
    }

    if (hotels.rating!.numberOfReviews.toString().isNotEmpty) {
      spans.add(VisaTextSpan(
        text: ' • ',
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.black,
        fontSize: AppSizes.fontTwelve,
        fontFamily: VisaFontWeight.regular,
        lineHeight: 1.33,
      ));

      spans.add(VisaTextSpan(
        text: "${hotels.rating!.numberOfReviews} ${s.reviews}",
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.custom,
        customColor: VisaColors.black,
        fontSize: AppSizes.fontTwelve,
        fontFamily: VisaFontWeight.regular,
        lineHeight: 1.33,
      ));
    }

    return spans;
  }

  /// Builds the full address
  Widget _buildFullAddress(S s) {
    return VisaTextView(
      semanticsLabel: _getFullAddressSemanticsLabel(s),
      text: _getFullAddressText(),
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

  /// Gets the full address semantics label
  String _getFullAddressSemanticsLabel(S s) {
    return '${s.address}: ${hotels.location!.address}, ${hotels.location!.city!.cityName}, ${hotels.location!.postalCode}';
  }

  /// Gets the full address text
  String _getFullAddressText() {
    return "${hotels.location!.address}, ${hotels.location!.city!.cityName}, ${hotels.location!.postalCode}";
  }

  /// Builds the booking button
  Widget _buildBookingButton(S s) {
    return VisaButton(
      text: s.open_on_booking,
      onPressed: () => _handleBookingTap(),
      fontWeight: VisaFontWeight.medium,
      variant: VisaButtonVariant.primary,
      lineHeight: 1.39,
    );
  }

  /// Handles booking button tap
  void _handleBookingTap() {
    chatProvider.navigateToRedirectingScreen(
      hotels.url!,
      deeplink: hotels.bookingUrl!,
      isRedirectToBooking: true,
    );
  }
}
