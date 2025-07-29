import 'package:flutter/material.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import 'visa_custom_search_text_field.dart';

class VisaAutoCompleteSearchView<T extends Object> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabelExtractor;
  final Widget? searchIcon;
  final Color? searchColor;
  final UnderlineInputBorder? border;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final String hintText;
  final ValueChanged<T>? onSelected;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final bool? filled;
  final VoidCallback? onTap;
  final Icon? suffixIcon;
  final Color? suffixIconColor;
  final bool isUpperCase;
  final bool semantics;
  final int? semanticsIndex;
  final int? labelSemanticsIndex;
  final String? semanticsLabel;
  final ValueChanged<String>? onSubmitted;

  const VisaAutoCompleteSearchView({
    super.key,
    required this.items,
    required this.itemLabelExtractor, // Function to get string from T
    this.searchIcon,
    this.searchColor,
    this.border,
    this.padding,
    this.height,
    this.width,
    this.hintText = 'Search...',
    this.onSelected,
    this.onChanged,
    this.filled = true,
    this.isUpperCase = false,
    this.onTap,
    this.fillColor = Colors.white,
    this.suffixIconColor = Colors.black,
    this.suffixIcon,
    this.semantics = true,
    this.semanticsIndex,
    this.labelSemanticsIndex,
    this.semanticsLabel,
    this.onSubmitted,
  });

  @override
  VisaAutoCompleteSearchViewState<T> createState() =>
      VisaAutoCompleteSearchViewState<T>();
}

class VisaAutoCompleteSearchViewState<T extends Object>
    extends State<VisaAutoCompleteSearchView<T>> {
  final TextEditingController controller = TextEditingController();
  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        showClearIcon = controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(8.0),
      height: widget.height ?? 50,
      width: widget.width ?? double.infinity,
      child: Autocomplete<T>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return Iterable<T>.empty();
          }
          return widget.items.where(
            (T item) => widget
                .itemLabelExtractor(item)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()),
          );
        },
        displayStringForOption: widget.itemLabelExtractor,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
          return const SizedBox.shrink(); // Hides the dropdown list
        },
        // UnComment Below Code if want to autocomplete dropdown list.
        // optionsViewBuilder: (BuildContext context,
        //     AutocompleteOnSelected<String> onSelected,
        //     Iterable<String> options) {
        //   return Align(
        //     alignment: Alignment.topLeft,
        //     child: Container(
        //       width: width! * 0.92,
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         border: Border.all(
        //           color: searchColor ?? Colors.grey,
        //         ),
        //         borderRadius: BorderRadius.circular(8.r),
        //       ),
        //       child: ListView.separated(
        //         padding: EdgeInsets.zero,
        //         shrinkWrap: true,
        //         itemCount: options.length,
        //         separatorBuilder: (context, index) => Divider(
        //           color: Colors.grey,
        //           thickness: Sizes.one,
        //           height: Sizes.three,
        //         ),
        //         itemBuilder: (BuildContext context, int index) {
        //           final String option = options.elementAt(index);
        //           return InkWell(
        //             onTap: () => onSelected(option),
        //             child: Container(
        //               padding: EdgeInsets.all( AppSizes.tenRadius),
        //               margin: EdgeInsets.symmetric(
        //                 vertical: 5.r,
        //                 horizontal:  AppSizes.tenRadius,
        //               ),
        //               width: width ?? double.infinity,
        //               child: VisaTextView(
        //                 text: option,
        //                 fontFamily: VisaFontWeight.medium,
        //                 colorTheme: VisaTextTheme.primaryDark,
        //                 style: VisaTextStyle.displayBodyXs,
        //                 fontSize: 12.sp,
        //                 letterSpacing: Sizes.two,
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //   );
        // },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return VisaCustomSearchTextField(
            semantics: widget.semantics,
            semanticsIndex: widget.semanticsIndex,
            semanticsLabel: widget.semanticsLabel,
            labelSemanticsIndex: widget.labelSemanticsIndex,
            controller: controller,
            focusNode: focusNode,
            onTap: () => widget.onTap?.call(),
            hintText: widget.hintText,
            isUpperCase: widget.isUpperCase,
            prefixIcon: widget.searchIcon,
            suffixIcon: showClearIcon
                ? IconButton(
                    icon: widget.suffixIcon ??
                        Icon(
                          Icons.clear,
                          size: AppSizes.sixteenRadius,
                        ),
                    color: widget.suffixIconColor,
                    onPressed: () {
                      controller.clear();
                      setState(() {
                        showClearIcon = false;
                      });
                    },
                  )
                : null,
            filled: widget.filled!,
            fillColor: widget.fillColor,
            border: widget.border,
            onSubmitted: widget.onSubmitted,
            onChanged: (String value) {
              widget.onChanged?.call(value);
            },
          );
        },
        onSelected: widget.onSelected ?? (T selection) {},
      ),
    );
  }
}
