import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';

import '../../../../custom_widgets/visa_textview.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../providers/home_provider.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({super.key});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  late HomeViewProvider homeViewProvider;
  late S s; // Localized strings

  @override
  void initState() {
    super.initState();
    // Retrieve HomeViewProvider using GetIt
    homeViewProvider = GetIt.I<HomeViewProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BaseView<HomeViewProvider>(
      viewModel: homeViewProvider,
      onPageBuilderMobileView:
          (BuildContext context, HomeViewProvider viewModel) {
        return Center(
          child: InkWell(
            radius: Sizes.twenty,
            onTap: () => viewModel.homeDetailsScreen2(),
            child: VisaTextView(
              text: "${s.home} Details",
              style: VisaTextStyle.custom,
              fontSize: Sizes.eighteen,
            ),
          ),
        );
      },
    );
  }
}
