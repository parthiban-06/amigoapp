import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../../generated/l10n.dart';
import '../../providers/home_provider.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  late HomeViewProvider homeViewProvider;

  @override
  void initState() {
    super.initState();
    homeViewProvider = GetIt.I<HomeViewProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BaseView<HomeViewProvider>(
      viewModel: homeViewProvider,
      onModelReady: (model) {},
      onlyDesktop: true,
      onPageBuilderMobileView:
          (BuildContext context, HomeViewProvider viewModel) {
        return Center(
          child: InkWell(
            radius: AppSizes.twentyRadius,
            onTap: () => viewModel.ticketsNavDetailsScreen(),
            child: VisaTextView(
              text: s.tickets,
              style: VisaTextStyle.custom,
              fontSize: AppSizes.eightteenRadius,
            ),
          ),
        );
      },
    );
  }
}
