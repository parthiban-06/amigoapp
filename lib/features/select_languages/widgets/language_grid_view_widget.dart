import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/language_selection_provider.dart';
import '../widgets/language_grid.dart';

class LanguageGridViewWidget extends StatelessWidget {
  final SelectLanguageProvider? viewModel;
  final bool isDesktop;
  final bool isMobileWeb;

  const LanguageGridViewWidget({
    super.key,
    required this.viewModel,
    required this.isDesktop,
    required this.isMobileWeb,
  });

  @override
  Widget build(BuildContext context) {
    return (viewModel?.languageList != null &&
            viewModel!.languageList!.isNotEmpty)
        ? GridView.builder(
            shrinkWrap: isMobileWeb || isDesktop ? true : false,
            padding: EdgeInsets.only(bottom: 8.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 94.h,
              crossAxisSpacing: 16.w, // ✅ Scaled properly using `.w`
              mainAxisSpacing: 16.h, // ✅ Scaled properly using `.h`
            ),
            itemCount: viewModel?.languageList?.length,
            itemBuilder: (context, index) {
              final language = viewModel?.languageList![index];
              final isSelected =
                  language?.langCode == viewModel?.selectedLanguage;

              return LanguageCard(
                language: language!,
                isSelected: isSelected,
                onTap: () => viewModel?.setLanguage(language),
              );
            },
          )
        : Container();
  }
}
