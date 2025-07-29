import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:visaamigo/custom_widgets/accordion/accordion.dart';
import 'package:visaamigo/custom_widgets/accordion/controllers.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';

/// `AccordionSection` is one section within the `Accordion` widget.
/// Usage:
/// ```dart
/// Accordion(
/// 	maxOpenSections: 1,
/// 	leftIcon: Icon(Icons.audiotrack, color: Colors.white),
/// 	children: [
/// 		AccordionSection(
/// 			isOpen: true,
/// 			header: Text('Introduction', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 			content: Icon(Icons.airplanemode_active, size: 200),
/// 		),
/// 		AccordionSection(
/// 			isOpen: true,
/// 			header: Text('About Us', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 			content: Icon(Icons.airline_seat_flat, size: 120),
/// 		),
/// 		AccordionSection(
/// 			isOpen: true,
/// 			header: Text('Company Info', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 			content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
/// 		),
/// 	],
/// )
/// ```
class AccordionSection extends StatelessWidget with CommonParams {
  final SectionController sectionCtrl = SectionController();
  late final UniqueKey uniqueKey;
  late final int index;
  final bool isOpen;

  /// Callback function for when a section opens
  final Function? onOpenSection;

  /// Callback functionf or when a section closes
  final Function? onCloseSection;

  /// The text to be displayed in the header
  final Widget header;

  /// The widget to be displayed as the content of the section when open
  final Widget content;

  AccordionSection({
    super.key,
    this.index = 0,
    this.isOpen = false,
    required this.header,
    required this.content,
    Color? headerBackgroundColor,
    Color? headerBackgroundColorOpened,
    Color? headerBorderColor,
    Color? headerBorderColorOpened,
    double? headerBorderWidth,
    double? headerBorderRadius,
    EdgeInsets? headerPadding,
    Widget? leftIcon,
    Widget? rightIcon,
    Widget? moveUpIcon,
    Color? contentBackgroundColor,
    Color? contentBorderColor,
    double? contentBorderWidth,
    double? contentBorderRadius,
    double? contentHorizontalPadding,
    double? contentVerticalPadding,
    double? paddingBetweenOpenSections,
    double? paddingBetweenClosedSections,
    ScrollIntoViewOfItems? scrollIntoViewOfItems,
    SectionHapticFeedback? sectionOpeningHapticFeedback,
    SectionHapticFeedback? sectionClosingHapticFeedback,
    String? accordionId,
    this.onOpenSection,
    this.onCloseSection,
  }) {
    final listCtrl = Get.put(ListController(), tag: accordionId);
    uniqueKey = listCtrl.keys.elementAt(index);
    sectionCtrl.isSectionOpen.value = listCtrl.openSections.contains(uniqueKey);

    this.headerBackgroundColor = headerBackgroundColor;
    this.headerBackgroundColorOpened =
        headerBackgroundColorOpened ?? headerBackgroundColor;
    this.headerBorderColor = headerBorderColor ?? headerBackgroundColor;
    this.headerBorderColorOpened =
        headerBorderColorOpened ?? headerBackgroundColorOpened;
    this.headerBorderWidth = headerBorderWidth;
    this.headerBorderRadius = headerBorderRadius;
    this.headerPadding = headerPadding;
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon;
    this.moveUpIcon = moveUpIcon;

    this.contentBackgroundColor = contentBackgroundColor;
    this.contentBorderColor = contentBorderColor;
    this.contentBorderWidth = contentBorderWidth;
    this.contentBorderRadius = contentBorderRadius;
    this.contentHorizontalPadding = contentHorizontalPadding;
    this.contentVerticalPadding = contentVerticalPadding;
    this.paddingBetweenOpenSections = paddingBetweenOpenSections;
    this.paddingBetweenClosedSections = paddingBetweenClosedSections;
    this.scrollIntoViewOfItems =
        scrollIntoViewOfItems ?? ScrollIntoViewOfItems.fast;
    this.sectionOpeningHapticFeedback = sectionOpeningHapticFeedback;
    this.sectionClosingHapticFeedback = sectionClosingHapticFeedback;
    this.accordionId = accordionId;

    listCtrl.controllerIsOpen.stream.asBroadcastStream().listen((data) {
      sectionCtrl.isSectionOpen.value = listCtrl.openSections.contains(key);
    });
  }

  /// getter to flip the widget vertically (Icon by default)
  /// on the left of this section header to visually indicate
  /// if this section is open or closed
  get _flipQuarterTurnsLeft =>
      SectionController.flipLeftIconIfOpen && _isOpen ? 2 : 0;

  /// getter to flip the widget vertically (Icon by default)
  /// on the right of this section header to visually indicate
  /// if this section is open or closed
  get _flipQuarterTurnsRight =>
      SectionController.flipRightIconIfOpen && _isOpen ? 2 : 0;

  /// getter indication the open or closed status of this section
  get _isOpen {
    final listCtrl = Get.put(ListController(), tag: accordionId);
    final open = sectionCtrl.isSectionOpen.value;

    Timer(
      sectionCtrl.firstRun
          ? (listCtrl.initialOpeningSequenceDelay + min(index * 200, 1000))
              .milliseconds
          : 0.seconds,
      () {
        if (Accordion.sectionAnimation) {
          sectionCtrl.controller
              .fling(velocity: open ? 1 : -1, springDescription: springFast);
        } else {
          sectionCtrl.controller.value = open ? 1 : 0;
        }
        sectionCtrl.firstRun = false;
      },
    );

    return open;
  }

  /// play haptic feedback when opening/closing sections
  _playHapticFeedback(bool opening) {
    final feedback =
        opening ? sectionOpeningHapticFeedback : sectionClosingHapticFeedback;

    switch (feedback) {
      case SectionHapticFeedback.light:
        HapticFeedback.lightImpact();
        break;
      case SectionHapticFeedback.medium:
        HapticFeedback.mediumImpact();
        break;
      case SectionHapticFeedback.heavy:
        HapticFeedback.heavyImpact();
        break;
      case SectionHapticFeedback.selection:
        HapticFeedback.selectionClick();
        break;
      case SectionHapticFeedback.vibrate:
        HapticFeedback.vibrate();
        break;
      default:
    }
  }

  /// Handle section tap events
  void _handleSectionTap() {
    final listCtrl = Get.put(ListController(), tag: accordionId);
    listCtrl.updateSections(uniqueKey);
    _playHapticFeedback(_isOpen);
    _handleScrollToSection(listCtrl);
    _handleSectionCallbacks();
  }

  /// Handle scrolling to section if needed
  void _handleScrollToSection(ListController listCtrl) {
    if (_isOpen &&
        scrollIntoViewOfItems != ScrollIntoViewOfItems.none &&
        listCtrl.controller.hasClients) {
      Timer(
        250.milliseconds,
        () {
          listCtrl.controller.cancelAllHighlights();
          listCtrl.controller.scrollToIndex(
            index,
            preferPosition: AutoScrollPosition.middle,
            duration: _getScrollDuration(),
          );
        },
      );
    }
  }

  /// Get scroll duration based on scroll type
  Duration _getScrollDuration() {
    return (scrollIntoViewOfItems == ScrollIntoViewOfItems.fast ? .5 : 1)
        .seconds;
  }

  /// Handle section open/close callbacks
  void _handleSectionCallbacks() {
    if (_isOpen) {
      onCloseSection?.call();
    } else {
      onOpenSection?.call();
    }
  }

  /// Build header decoration
  BoxDecoration _buildHeaderDecoration(
      double borderRadius, BuildContext context) {
    return BoxDecoration(
      color: _getHeaderBackgroundColor(context),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
        bottom: Radius.circular(_isOpen ? 0 : borderRadius),
      ),
      border: Border.all(
        color: _getHeaderBorderColor(context),
        width: (headerBorderWidth ?? 0),
        style: (headerBorderWidth ?? 0) <= 0
            ? BorderStyle.none
            : BorderStyle.solid,
      ),
    );
  }

  /// Get header background color
  Color _getHeaderBackgroundColor(BuildContext context) {
    return (_isOpen ? headerBackgroundColorOpened : headerBackgroundColor) ??
        Theme.of(context).primaryColor;
  }

  /// Get header border color
  Color _getHeaderBorderColor(BuildContext context) {
    return (_isOpen ? headerBorderColorOpened : headerBorderColor) ??
        Theme.of(context).primaryColor;
  }

  /// Build header content with icons and text
  Widget _buildHeaderContent() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (localLanguageProvider.isRTL) _buildLeftIcon(),
        Align(
          alignment: Alignment.center,
          child: header,
        ),
        if (rightIcon != null &&
            moveUpIcon != null &&
            !localLanguageProvider.isRTL)
          _buildRightIcon(),
      ],
    );
  }

  /// Build left icon widget
  Widget _buildLeftIcon() {
    return Positioned(
        left: 0,
        top: 0,
        child: _flipQuarterTurnsLeft == 0 ? leftIcon! : moveUpIcon!
        //  RotatedBox(
        //   quarterTurns: _flipQuarterTurnsLeft,
        //   child: leftIcon!,
        // ),
        );
  }

  /// Build right icon widget
  Widget _buildRightIcon() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: _flipQuarterTurnsRight == 0 ? rightIcon! : moveUpIcon!,
      // RotatedBox(
      //   quarterTurns: _flipQuarterTurnsRight,
      //   child: rightIcon!,
      // ),
    );
  }

  /// Build content container with styling
  Widget _buildContentContainer(
      double contentBorderRadius, BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: contentBorderColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(contentBorderRadius),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          contentBorderWidth ?? 1,
          0,
          contentBorderWidth ?? 1,
          contentBorderWidth ?? 1,
        ),
        child: _buildInnerContentContainer(contentBorderRadius),
      ),
    );
  }

  /// Build inner content container
  Widget _buildInnerContentContainer(double contentBorderRadius) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(contentBorderRadius / 1.02),
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: contentBackgroundColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(contentBorderRadius / 1.02),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: contentHorizontalPadding ?? 10,
            vertical: contentVerticalPadding ?? 10,
          ),
          child: Center(child: content),
        ),
      ),
    );
  }

  /// Build the header widget
  Widget _buildHeader(double borderRadius, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
        bottom: Radius.circular(_isOpen ? 0 : borderRadius),
      ),
      onTap: _handleSectionTap,
      child: AnimatedContainer(
        duration:
            Accordion.sectionAnimation ? 750.milliseconds : 0.milliseconds,
        curve: Curves.easeOut,
        alignment: Alignment.center,
        padding: headerPadding,
        decoration: _buildHeaderDecoration(borderRadius, context),
        child: _buildHeaderContent(),
      ),
    );
  }

  /// Build the content widget
  Widget _buildContent(double contentBorderRadius, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: _isOpen
            ? paddingBetweenOpenSections ?? 10
            : paddingBetweenClosedSections ?? 10,
      ),
      child: SizeTransition(
        sizeFactor: sectionCtrl.controller,
        child: ScaleTransition(
          scale: Accordion.sectionScaleAnimation
              ? sectionCtrl.controller
              : const AlwaysStoppedAnimation(1.0),
          child: Center(
            child: _buildContentContainer(contentBorderRadius, context),
          ),
        ),
      ),
    );
  }

  late SelectLanguageGenericProvider localLanguageProvider;
  @override
  build(context) {
    final borderRadius = headerBorderRadius ?? 10;
    final contentBorderRadius = this.contentBorderRadius ?? 10;
    localLanguageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);
    return Obx(
      () => Column(
        key: uniqueKey,
        children: [
          _buildHeader(borderRadius, context),
          _buildContent(contentBorderRadius, context),
        ],
      ),
    );
  }
}
