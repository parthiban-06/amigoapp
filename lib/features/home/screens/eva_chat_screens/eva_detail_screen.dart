import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';

import '../../../../custom_widgets/visa_textview.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../providers/home_provider.dart';

class EvaDetailScreen extends StatefulWidget {
  const EvaDetailScreen({super.key});

  @override
  State<EvaDetailScreen> createState() => _EvaDetailScreenState();
}

class _EvaDetailScreenState extends State<EvaDetailScreen> {
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
          child: VisaTextView(
            text: "${s.eva} Details",
            style: VisaTextStyle.custom,
            fontSize: AppSizes.fontMedium,
          ),
        );
      },
    );
  }
}
