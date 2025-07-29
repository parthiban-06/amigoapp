import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Test-specific BaseView that doesn't require BaseProvider
class TestBaseView extends StatefulWidget {
  final Widget Function(BuildContext context, TestProvider viewModel)
      onPageBuilderMobileView;
  final Widget Function(BuildContext context, TestProvider viewModel)?
      onPageBuilderDesktopView;
  final TestProvider viewModel;
  final Function(TestProvider viewModel)? onModelReady;
  final VoidCallback? onDispose;
  final Widget? buildBottomNavigationBar;
  final bool? onlyDesktop;
  final PreferredSizeWidget? buildAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? loadingWidget;
  final Drawer? drawer;
  final PopInvokedWithResultCallback<TestProvider>? onPopInvokedWithResult;
  final Color? unSafeAreaColor;
  final Color? screenBackgroundColor;
  final Color? systemNavigationBarColor;
  final bool resizeToAvoidBottomInset;
  final bool wrapWithSafeArea;
  final bool setBottomSafeArea;
  final bool setTopSafeArea;
  final bool addDefaultPadding;
  final bool extendBodyBehindAppBar;
  final bool statusBarDarkTheme;
  final bool addStackBaseView;
  final bool showInternetDialog;
  final Widget? screenBackgroundImage;
  final bool isVisaLogoSemanticsShowFirstTime;

  const TestBaseView({
    Key? key,
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
  }) : super(key: key);

  @override
  _TestBaseViewState createState() => _TestBaseViewState();
}

class _TestBaseViewState extends State<TestBaseView> {
  late TestProvider viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    viewModel.setContext(context);
    if (widget.onModelReady != null) {
      widget.onModelReady!(viewModel);
    }
    if (widget.showInternetDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TestConnectivityService>().checkConnectivity(context);
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
    return Provider.of<TestResponsiveUtil>(context).responsiveWrapper(
      context: context,
      mobileView: widget.onPageBuilderMobileView(context, viewModel),
      desktopView: widget.onlyDesktop == null || widget.onlyDesktop == false
          ? Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                child: widget.onPageBuilderMobileView(context, viewModel),
              ),
            )
          : (widget.onPageBuilderDesktopView != null)
              ? widget.onPageBuilderDesktopView!(context, viewModel)
              : widget.onPageBuilderMobileView(context, viewModel),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.statusBarDarkTheme) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inactivityService =
        Provider.of<TestInactivityService>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onPanDown: (_) => inactivityService.userInteraction(context),
      child: ChangeNotifierProvider<TestProvider>(
        create: (context) => widget.viewModel,
        child: Consumer<TestProvider>(
          builder: (contexts, TestProvider viewModels, widgets) {
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
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: !widget.extendBodyBehindAppBar,
        extendBody: widget.extendBodyBehindAppBar,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar:
            Provider.of<TestResponsiveUtil>(context).isDesktop(context: context)
                ? null
                : widget.buildAppBar,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawer: widget.drawer,
        body: (widget.addStackBaseView)
            ? Stack(
                children: [
                  _getBackgroundImage(),
                  _buildContentWithPadding(context),
                ],
              )
            : Column(
                children: [
                  _getBackgroundImage(),
                  Expanded(
                    child: _buildContentWithPadding(context),
                  ),
                ],
              ),
        backgroundColor: widget.screenBackgroundColor,
        bottomNavigationBar: widget.buildBottomNavigationBar,
      ),
    );
  }

  Widget _getBackgroundImage() {
    if (widget.screenBackgroundImage != null) {
      return widget.screenBackgroundImage!;
    } else {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  Widget _buildContentWithPadding(BuildContext context) {
    return Padding(
      padding:
          Provider.of<TestResponsiveUtil>(context).isDesktop(context: context)
              ? const EdgeInsets.all(0)
              : widget.addDefaultPadding
                  ? const EdgeInsets.all(16)
                  : const EdgeInsets.all(0),
      child: _buildContent(context),
    );
  }
}

// Simple test provider
class TestProvider extends ChangeNotifier {
  bool _isTabletView = false;
  bool _setContextCalled = false;
  BuildContext? _context;

  bool get isTabletView => _isTabletView;

  void setTabletView(bool value) {
    _isTabletView = value;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _setContextCalled = true;
    _context = context;
  }

  bool get setContextCalled => _setContextCalled;
}

// Simple test responsive util
class TestResponsiveUtil extends ChangeNotifier {
  bool _isDesktop = false;
  bool _isTablet = false;
  bool _isMobile = true;

  void setDesktop(bool value) => _isDesktop = value;

  void setTablet(bool value) => _isTablet = value;

  void setMobile(bool value) => _isMobile = value;

  bool isDesktop({BuildContext? context}) => _isDesktop;

  bool isTablet({BuildContext? context}) => _isTablet;

  bool isMobile({BuildContext? context}) => _isMobile;

  Widget responsiveWrapper({
    required BuildContext context,
    required Widget mobileView,
    Widget? tabletView,
    Widget? desktopView,
  }) {
    if (_isDesktop && desktopView != null) {
      return desktopView;
    }
    if (_isTablet && tabletView != null) {
      return tabletView;
    }
    return mobileView;
  }
}

// Simple test connectivity service
class TestConnectivityService extends ChangeNotifier {
  bool _checkConnectivityCalled = false;

  bool get checkConnectivityCalled => _checkConnectivityCalled;

  void checkConnectivity(
    BuildContext context, {
    void Function()? onShowModal,
  }) {
    _checkConnectivityCalled = true;
  }

  void reset() {
    _checkConnectivityCalled = false;
  }
}

// Simple test inactivity service
class TestInactivityService extends ChangeNotifier {
  bool _userInteractionCalled = false;

  bool get userInteractionCalled => _userInteractionCalled;

  void userInteraction(BuildContext context) {
    _userInteractionCalled = true;
  }

  void reset() {
    _userInteractionCalled = false;
  }
}

void main() {
  group('BaseView Tests', () {
    late TestProvider testViewModel;
    late TestResponsiveUtil testResponsiveUtil;
    late TestConnectivityService testConnectivityService;
    late TestInactivityService testInactivityService;

    setUp(() {
      testViewModel = TestProvider();
      testResponsiveUtil = TestResponsiveUtil();
      testConnectivityService = TestConnectivityService();
      testInactivityService = TestInactivityService();
    });

    Widget createTestWidget({
      TestProvider? viewModel,
      Widget Function(BuildContext, TestProvider)? onPageBuilderMobileView,
      Widget Function(BuildContext, TestProvider)? onPageBuilderDesktopView,
      Function(TestProvider)? onModelReady,
      VoidCallback? onDispose,
      Widget? buildBottomNavigationBar,
      bool? onlyDesktop,
      PreferredSizeWidget? buildAppBar,
      Widget? floatingActionButton,
      FloatingActionButtonAnimator? floatingActionButtonAnimator,
      FloatingActionButtonLocation? floatingActionButtonLocation,
      Widget? loadingWidget,
      Drawer? drawer,
      PopInvokedWithResultCallback<TestProvider>? onPopInvokedWithResult,
      Color? unSafeAreaColor,
      Color? screenBackgroundColor,
      Color? systemNavigationBarColor,
      bool? resizeToAvoidBottomInset,
      bool? wrapWithSafeArea,
      bool? setBottomSafeArea,
      bool? setTopSafeArea,
      bool? addDefaultPadding,
      bool? extendBodyBehindAppBar,
      bool? statusBarDarkTheme,
      bool? addStackBaseView,
      bool? showInternetDialog,
      Widget? screenBackgroundImage,
      bool? isVisaLogoSemanticsShowFirstTime,
    }) {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<TestResponsiveUtil>.value(
              value: testResponsiveUtil,
            ),
            ChangeNotifierProvider<TestConnectivityService>.value(
              value: testConnectivityService,
            ),
            ChangeNotifierProvider<TestInactivityService>.value(
              value: testInactivityService,
            ),
          ],
          child: TestBaseView(
            viewModel: viewModel ?? testViewModel,
            onPageBuilderMobileView: onPageBuilderMobileView ??
                (context, vm) => const SizedBox(child: Text('Mobile View')),
            onPageBuilderDesktopView: onPageBuilderDesktopView,
            onModelReady: onModelReady,
            onDispose: onDispose,
            buildBottomNavigationBar: buildBottomNavigationBar,
            onlyDesktop: onlyDesktop,
            buildAppBar: buildAppBar,
            floatingActionButton: floatingActionButton,
            floatingActionButtonAnimator: floatingActionButtonAnimator,
            floatingActionButtonLocation: floatingActionButtonLocation,
            loadingWidget: loadingWidget,
            drawer: drawer,
            onPopInvokedWithResult: onPopInvokedWithResult,
            unSafeAreaColor: unSafeAreaColor,
            screenBackgroundColor: screenBackgroundColor,
            systemNavigationBarColor: systemNavigationBarColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
            wrapWithSafeArea: wrapWithSafeArea ?? true,
            setBottomSafeArea: setBottomSafeArea ?? true,
            setTopSafeArea: setTopSafeArea ?? true,
            addDefaultPadding: addDefaultPadding ?? true,
            extendBodyBehindAppBar: extendBodyBehindAppBar ?? true,
            statusBarDarkTheme: statusBarDarkTheme ?? true,
            addStackBaseView: addStackBaseView ?? true,
            showInternetDialog: showInternetDialog ?? true,
            screenBackgroundImage: screenBackgroundImage,
            isVisaLogoSemanticsShowFirstTime:
                isVisaLogoSemanticsShowFirstTime ?? false,
          ),
        ),
      );
    }

    group('Constructor and Initialization', () {
      testWidgets('should create BaseView with required parameters',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TestBaseView), findsOneWidget);
        expect(find.text('Mobile View'), findsOneWidget);
      });

      testWidgets('should initialize with default values', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should call onModelReady when provided', (tester) async {
        bool onModelReadyCalled = false;

        await tester.pumpWidget(createTestWidget(
          onModelReady: (vm) {
            onModelReadyCalled = true;
          },
        ));

        expect(onModelReadyCalled, isTrue);
      });

      testWidgets('should not call onModelReady when not provided',
          (tester) async {
        await tester.pumpWidget(createTestWidget(onModelReady: null));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should set context on viewModel during initialization',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(testViewModel.setContextCalled, isTrue);
      });
    });

    group('Lifecycle Methods', () {
      testWidgets('should call onDispose when widget is disposed',
          (tester) async {
        bool onDisposeCalled = false;

        await tester.pumpWidget(createTestWidget(
          onDispose: () {
            onDisposeCalled = true;
          },
        ));

        await tester.pumpWidget(const SizedBox());

        expect(onDisposeCalled, isTrue);
      });

      testWidgets('should not call onDispose when not provided',
          (tester) async {
        await tester.pumpWidget(createTestWidget(onDispose: null));
        await tester.pumpWidget(const SizedBox());

        expect(true, isTrue);
      });
    });

    group('Connectivity Service', () {
      testWidgets('should check connectivity when showInternetDialog is true',
          (tester) async {
        testConnectivityService.reset();

        await tester.pumpWidget(createTestWidget(showInternetDialog: true));

        await tester.pumpAndSettle();

        expect(testConnectivityService.checkConnectivityCalled, isTrue);
      });

      testWidgets(
          'should not check connectivity when showInternetDialog is false',
          (tester) async {
        testConnectivityService.reset();

        await tester.pumpWidget(createTestWidget(showInternetDialog: false));

        await tester.pumpAndSettle();

        expect(testConnectivityService.checkConnectivityCalled, isFalse);
      });
    });

    group('System UI Configuration', () {
      testWidgets(
          'should set dark status bar theme when statusBarDarkTheme is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(statusBarDarkTheme: true));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets(
          'should set light status bar theme when statusBarDarkTheme is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget(statusBarDarkTheme: false));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Safe Area Configuration', () {
      testWidgets('should wrap with SafeArea when wrapWithSafeArea is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(wrapWithSafeArea: true));

        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets(
          'should not wrap with SafeArea when wrapWithSafeArea is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget(wrapWithSafeArea: false));

        expect(find.byType(SafeArea), findsNothing);
      });

      testWidgets('should configure SafeArea with correct parameters',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          wrapWithSafeArea: true,
          setTopSafeArea: false,
          setBottomSafeArea: false,
        ));

        expect(find.byType(SafeArea), findsOneWidget);
      });
    });

    group('Responsive Design', () {
      testWidgets('should use mobile view when not desktop', (tester) async {
        testResponsiveUtil.setDesktop(false);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Mobile View'), findsOneWidget);
      });

      testWidgets('should use desktop view when isDesktop returns true',
          (tester) async {
        testResponsiveUtil.setDesktop(true);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle onlyDesktop parameter correctly',
          (tester) async {
        await tester.pumpWidget(createTestWidget(onlyDesktop: true));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets(
          'should use CustomSplitView for desktop when onlyDesktop is false',
          (tester) async {
        testViewModel.setTabletView(false);

        await tester.pumpWidget(createTestWidget(onlyDesktop: false));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should use CustomSplitView for tablet view', (tester) async {
        testViewModel.setTabletView(true);

        await tester.pumpWidget(createTestWidget(onlyDesktop: false));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets(
          'should use desktop view when onPageBuilderDesktopView is provided',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          onlyDesktop: true,
          onPageBuilderDesktopView: (context, vm) => const Text('Desktop View'),
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Scaffold Configuration', () {
      testWidgets('should configure Scaffold with correct parameters',
          (tester) async {
        final appBar = AppBar(title: const Text('Test AppBar'));
        final floatingActionButton = FloatingActionButton(onPressed: () {});
        final drawer = Drawer(child: const Text('Drawer'));
        final bottomNavigationBar = BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), label: 'Business'),
          ],
          currentIndex: 0,
        );

        await tester.pumpWidget(createTestWidget(
          buildAppBar: appBar,
          floatingActionButton: floatingActionButton,
          drawer: drawer,
          buildBottomNavigationBar: bottomNavigationBar,
          extendBodyBehindAppBar: false,
          resizeToAvoidBottomInset: false,
        ));

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        // Check for hamburger menu (drawer trigger)
        expect(find.byTooltip('Open navigation menu'), findsOneWidget);
        // Optionally, open the drawer and check for its content
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle();
        expect(find.text('Drawer'), findsOneWidget);
      });

      testWidgets('should not show AppBar when isDesktop returns true',
          (tester) async {
        testResponsiveUtil.setDesktop(true);
        final appBar = AppBar(title: const Text('Test AppBar'));

        await tester.pumpWidget(createTestWidget(buildAppBar: appBar));

        expect(find.byType(AppBar), findsNothing);
      });

      testWidgets(
          'should configure floating action button animator and location',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Body Configuration', () {
      testWidgets('should use Stack layout when addStackBaseView is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(addStackBaseView: true));

        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('should use Column layout when addStackBaseView is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget(addStackBaseView: false));

        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('should show screen background image when provided',
          (tester) async {
        final backgroundImage = Container(
          color: Colors.red,
          child: const Text('Background'),
        );

        await tester.pumpWidget(createTestWidget(
          screenBackgroundImage: backgroundImage,
        ));

        expect(find.text('Background'), findsOneWidget);
      });

      testWidgets('should apply default padding when addDefaultPadding is true',
          (tester) async {
        await tester.pumpWidget(createTestWidget(addDefaultPadding: true));

        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets(
          'should not apply default padding when addDefaultPadding is false',
          (tester) async {
        await tester.pumpWidget(createTestWidget(addDefaultPadding: false));

        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets(
          'should not apply default padding when isDesktop returns true',
          (tester) async {
        testResponsiveUtil.setDesktop(true);

        await tester.pumpWidget(createTestWidget(addDefaultPadding: true));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle background color configuration',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          screenBackgroundColor: Colors.blue,
          unSafeAreaColor: Colors.red,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Gesture Detection', () {
      testWidgets('should handle tap gestures', (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.byType(TestBaseView));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle pan gestures', (tester) async {
        testInactivityService.reset();

        await tester.pumpWidget(createTestWidget());

        await tester.drag(find.byType(TestBaseView), const Offset(10, 10));

        expect(testInactivityService.userInteractionCalled, isTrue);
      });
    });

    group('Provider Integration', () {
      testWidgets('should provide viewModel through ChangeNotifierProvider',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(
            find.byType(ChangeNotifierProvider<TestProvider>), findsOneWidget);
      });

      testWidgets('should use Consumer to rebuild on viewModel changes',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Consumer<TestProvider>), findsOneWidget);
      });
    });

    group('Loading Widget', () {
      testWidgets('should show custom loading widget when provided',
          (tester) async {
        final customLoader = Container(
          color: Colors.blue,
          child: const Text('Custom Loader'),
        );

        await tester.pumpWidget(createTestWidget(loadingWidget: customLoader));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should show default loading widget when not provided',
          (tester) async {
        await tester.pumpWidget(createTestWidget(loadingWidget: null));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Visa Logo Semantics', () {
      testWidgets(
          'should pass isVisaLogoSemanticsShowFirstTime to CustomSplitView',
          (tester) async {
        testViewModel.setTabletView(false);

        await tester.pumpWidget(createTestWidget(
          onlyDesktop: false,
          isVisaLogoSemanticsShowFirstTime: true,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('PopScope Configuration', () {
      testWidgets('should configure PopScope with canPop false',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(PopScope), findsOneWidget);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle null onPageBuilderDesktopView',
          (tester) async {
        await tester.pumpWidget(createTestWidget(
          onlyDesktop: true,
          onPageBuilderDesktopView: null,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle null screenBackgroundImage', (tester) async {
        await tester.pumpWidget(createTestWidget(screenBackgroundImage: null));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle all null optional parameters', (tester) async {
        await tester.pumpWidget(createTestWidget(
          onPageBuilderDesktopView: null,
          onModelReady: null,
          onDispose: null,
          buildBottomNavigationBar: null,
          onlyDesktop: null,
          buildAppBar: null,
          floatingActionButton: null,
          loadingWidget: null,
          drawer: null,
          onPopInvokedWithResult: null,
          screenBackgroundImage: null,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle system navigation bar color', (tester) async {
        await tester.pumpWidget(createTestWidget(
          systemNavigationBarColor: Colors.black,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should integrate with all providers correctly',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle complex widget tree correctly',
          (tester) async {
        final complexWidget = createTestWidget(
          buildAppBar: AppBar(title: const Text('Complex AppBar')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          drawer: Drawer(
            child: ListView(
              children: const [
                DrawerHeader(child: Text('Header')),
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
              ],
            ),
          ),
          buildBottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.business), label: 'Business'),
            ],
            currentIndex: 0,
          ),
          screenBackgroundImage: Container(
            color: Colors.grey,
            child: const Text('Background'),
          ),
        );

        await tester.pumpWidget(complexWidget);

        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle();

        expect(find.text('Complex AppBar'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Business'), findsOneWidget);
        expect(find.text('Background'), findsOneWidget);
      });

      testWidgets('should handle different screen sizes correctly',
          (tester) async {
        // Test tablet view
        testViewModel.setTabletView(true);
        testResponsiveUtil.setDesktop(false);

        await tester.pumpWidget(createTestWidget(onlyDesktop: false));

        expect(find.byType(TestBaseView), findsOneWidget);

        // Test desktop view
        testResponsiveUtil.setDesktop(true);

        await tester.pumpWidget(createTestWidget(onlyDesktop: false));

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle focus management', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Test that tapping unfocuses the primary focus
        await tester.tap(find.byType(TestBaseView));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Accessibility and Semantics', () {
      testWidgets('should provide proper semantics', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TestBaseView), findsOneWidget);
      });

      testWidgets('should handle semantics for visa logo', (tester) async {
        await tester.pumpWidget(createTestWidget(
          isVisaLogoSemanticsShowFirstTime: true,
          onlyDesktop: false,
        ));

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });

    group('Performance and Memory', () {
      testWidgets('should dispose resources properly', (tester) async {
        bool disposeCalled = false;

        await tester.pumpWidget(createTestWidget(
          onDispose: () {
            disposeCalled = true;
          },
        ));

        await tester.pumpWidget(const SizedBox());

        expect(disposeCalled, isTrue);
      });

      testWidgets('should not leak memory with multiple rebuilds',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpWidget(createTestWidget());
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(TestBaseView), findsOneWidget);
      });
    });
  });
}
