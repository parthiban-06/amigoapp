import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../../generated/l10n.dart';
import '../../providers/home_provider.dart';

class EvaChatScreen extends StatefulWidget {
  const EvaChatScreen({super.key});

  @override
  State<EvaChatScreen> createState() => _EvaChatScreenState();
}

class _EvaChatScreenState extends State<EvaChatScreen> {
  late HomeViewProvider homeViewProvider;
  late S s; // Localized strings

  @override
  void initState() {
    super.initState();
    homeViewProvider = GetIt.I<HomeViewProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewProvider>(
      viewModel: homeViewProvider,
      onPageBuilderMobileView:
          (BuildContext context, HomeViewProvider viewModel) {
        return Center(
          child: InkWell(
            radius: Sizes.twenty,
            onTap: () => viewModel.evaNavDetailsScreen(),
            child: VisaTextView(
              text: s.eva,
              style: VisaTextStyle.custom,
              fontSize: AppSizes.fontMedium,
            ),
          ),
        );
      },
    );
  }
}
