import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/utils/Inactive_session.dart';

import '../../../custom_widgets/custom_split_view.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/connectivity_service.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/responsive_util.dart';

class BaseView<T extends BaseProvider<dynamic>> extends StatefulWidget {
  final Widget Function(BuildContext context, T viewModel)
      onPageBuilderMobileView;
  final Widget Function(BuildContext context, T viewModel)?
      onPageBuilderDesktopView;
  final T viewModel;
  final Function(T viewModel)? onModelReady;
  final VoidCallback? onDispose;
  final Widget? buildBottomNavigationBar;
  final bool? onlyDesktop;
  final PreferredSizeWidget? buildAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? loadingWidget;
  final Drawer? drawer;
  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;

  //default base UI config
  Color? unSafeAreaColor = AppColor.white;
  Color? screenBackgroundColor = AppColor.white;
  Color? systemNavigationBarColor;
  bool resizeToAvoidBottomInset = true;
  bool wrapWithSafeArea = true;
  bool setBottomSafeArea = true;
  bool setTopSafeArea = true;
  bool addDefaultPadding = true;
  bool extendBodyBehindAppBar = true;
  bool statusBarDarkTheme = true;
  bool addStackBaseView = true;
  bool showInternetDialog = true;
  bool allowBackPress = false;
  final Widget? screenBackgroundImage;
  final bool isVisaLogoSemanticsShowFirstTime;

  BaseView({
    super.key,
    required this.viewModel,
    required this.onPageBuilderMobileView,
    this.onPageBuilderDesktopView,
    this.onlyDesktop,
    this.onModelReady,
    this.onDispose,
    this.buildBottomNavigationBar,
    this.buildAppBar,
    this.floatingActionButton,
    this.floatingActionButtonAnimator =
        FloatingActionButtonAnimator.noAnimation,
    this.floatingActionButtonLocation =
        FloatingActionButtonLocation.centerDocked,
    this.loadingWidget,
    this.resizeToAvoidBottomInset = true,
    this.addDefaultPadding = true,
    this.setBottomSafeArea = true,
    this.setTopSafeArea = true,
    this.allowBackPress = false,
    this.extendBodyBehindAppBar = true,
    this.wrapWithSafeArea = true,
    this.statusBarDarkTheme = true,
    this.addStackBaseView = true,
    this.screenBackgroundColor = Colors.white,
    this.unSafeAreaColor = Colors.white,
    this.systemNavigationBarColor,
    this.drawer,
    this.screenBackgroundImage,
    this.isVisaLogoSemanticsShowFirstTime = false,
    this.showInternetDialog = true,
    this.onPopInvokedWithResult,
  });

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends BaseProvider> extends State<BaseView<T>> {
  late T viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    viewModel.setContext(context);
    widget.onModelReady?.call(viewModel);
    //viewModel.checkConnectivity(context, connectivity);
    if (widget.showInternetDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ConnectivityService>().checkConnectivity(context);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call();
  }

  Widget _buildLoader() {
    return widget.loadingWidget ??
        const Center(
          child: CircularProgressIndicator(),
        );
  }

  Widget _buildContent(BuildContext context) {
    return Provider.of<ResponsiveUtil>(context).responsiveWrapper(
      context: context,
      mobileView: widget.onPageBuilderMobileView(context, viewModel),

      desktopView: widget.onlyDesktop == null || widget.onlyDesktop == false
          ? CustomSplitView(
              isDesktopView: !viewModel.isTabletView,
              isVisaLogoSemanticsShowFirstTime:
                  widget.isVisaLogoSemanticsShowFirstTime,
              rightWightView: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _getHorizontalPadding(),
                  vertical: Sizes.twentyInt.toDouble(),
                ),
                child: widget.onPageBuilderMobileView(context, viewModel),
              ),
            )
          : _getDesktopView(context),
      // desktopView: (widget.onPageBuilderDesktopView != null)
      //     ? widget.onPageBuilderDesktopView!(context, viewModel)
      //     : widget.onPageBuilderMobileView(context, viewModel),
    );
  }

  Widget _getDesktopView(BuildContext context) {
    return (widget.onPageBuilderDesktopView != null)
        ? widget.onPageBuilderDesktopView!(context, viewModel)
        : widget.onPageBuilderMobileView(context, viewModel);
  }

  double _getHorizontalPadding() {
    return viewModel.isTabletView
        ? Sizes.fortyInt.toDouble()
        : Sizes.oneHundredTwentyInt.toDouble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.statusBarDarkTheme) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // statusBarColor: Colors.white, // Change status bar color
        statusBarIconBrightness:
            Brightness.dark, // White icons (for dark background)
        // systemNavigationBarColor: widget.systemNavigationBarColor ??
        //     Colors.white // ✅ Set bottom bar color to white
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // statusBarColor: Colors.white, // Change status bar color
        statusBarIconBrightness:
            Brightness.dark, // White icons (for dark background)
        // systemNavigationBarColor: widget.systemNavigationBarColor ??
        //     Colors.white, // ✅ Set bottom bar color to white
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color
    // InActivity Code
    final inactivityService =
        Provider.of<InactivityService>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      // InActivity Code
      onPanDown: (_) => inactivityService.userInteraction(context),
      child: ChangeNotifierProvider<T>(
        create: (context) => widget.viewModel,
        child: Consumer<T>(
          builder: (contexts, T viewModels, widgets) {
            return widget.wrapWithSafeArea
                ? SafeArea(
                    top: widget.setTopSafeArea,
                    bottom: widget.setBottomSafeArea,
                    child: _buildScaffold(context),
                  )
                : _buildScaffold(context);
          },
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return PopScope(
      canPop: widget.allowBackPress,
      // onPopInvokedWithResult: widget.onPopInvokedWithResult,
      child: Scaffold(
        extendBodyBehindAppBar: !widget.extendBodyBehindAppBar,
        // Extends background under the AppBar
        // Global Key is responsible to close navigation drawer
        // key: GlobalKey<ScaffoldState>(),
        extendBody: widget.extendBodyBehindAppBar,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: _getAppBar(context),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawer: widget.drawer,
        body: _buildBody(context),
        backgroundColor: widget.screenBackgroundColor,
        bottomNavigationBar: widget.buildBottomNavigationBar,
      ),
    );
  }

  PreferredSizeWidget? _getAppBar(BuildContext context) {
    return Provider.of<ResponsiveUtil>(context).isDesktop(context: context)
        ? null
        : widget.buildAppBar;
  }

  Widget _buildBody(BuildContext context) {
    return widget.addStackBaseView
        ? _buildStackBody(context)
        : _buildColumnBody(context);
  }

  Widget _buildStackBody(BuildContext context) {
    return Stack(
      children: [
        _getBackgroundImage(),
        _buildContentWithPadding(context),
      ],
    );
  }

  Widget _buildColumnBody(BuildContext context) {
    return Column(
      children: [
        _getBackgroundImage(),
        Expanded(
          child: _buildContentWithPadding(context),
        ),
        // if (viewModel.isLoading) ...[
        //   const ModalBarrier(
        //       color: Colors.white30, dismissible: false),
        //   // Blocks touches
        //   const Center(child: CircularProgressIndicator()),
        //   // Loading Indicator
        // ],
      ],
    );
  }

  Widget _getBackgroundImage() {
    return widget.screenBackgroundImage ??
        SizedBox(
          width: AppSizes.zero,
          height: AppSizes.zero,
        );
  }

  Widget _buildContentWithPadding(BuildContext context) {
    return Padding(
      padding: _getContentPadding(context),
      child: _buildContent(context),
    );
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    final isDesktop =
        Provider.of<ResponsiveUtil>(context).isDesktop(context: context);
    if (isDesktop) {
      return const EdgeInsets.all(0);
    }
    return widget.addDefaultPadding
        ? EdgeInsets.all(16.r)
        : const EdgeInsets.all(0);
  }
}
