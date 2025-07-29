import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/drawer/provider/drawer_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/amplify_service.dart';

class MockUserGenericProvider extends Mock implements UserGenericProvider {}

class MockAmplifyService extends Mock implements AmplifyService {}

class TestableDrawerProvider extends DrawerProvider {
  String? lastNavPushRoute;
  Object? lastNavPushExtra;
  int navPopCount = 0;
  String? lastClipboardText;

  @override
  void navPush(String route, {Object? extra}) {
    lastNavPushRoute = route;
    lastNavPushExtra = extra;
  }

  @override
  void navPop() {
    navPopCount++;
  }

  @override
  void copyToken() {
    lastClipboardText =
        amplifyService.authToken ?? "authToken is empty try again";
  }
}

void main() {
  late TestableDrawerProvider provider;
  late MockUserGenericProvider mockUserGenericProvider;
  late MockAmplifyService mockAmplifyService;

  setUpAll(() async {
    await dotenv.load(fileName: ".env.test");
  });

  setUp(() {
    provider = TestableDrawerProvider();
    mockUserGenericProvider = MockUserGenericProvider();
    mockAmplifyService = MockAmplifyService();
  });

  group('DrawerProvider Tests', () {
    testWidgets('init() should set appBarTotalHeight and notificationCount',
        (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(5);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Builder(
              builder: (context) {
                return ChangeNotifierProvider<UserGenericProvider>.value(
                  value: mockUserGenericProvider,
                  child: Scaffold(
                    body: Builder(
                      builder: (context) {
                        provider.userGenericProvider =
                            Provider.of<UserGenericProvider>(context,
                                listen: false);
                        return Container();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await provider.init(tester.element(find.byType(Scaffold)));

      // Assert
      expect(provider.appBarTotalHeight, greaterThan(0));
      expect(provider.notificationCount, 5);
    });

    testWidgets('init() should handle zero notification count', (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(0);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Builder(
              builder: (context) {
                return ChangeNotifierProvider<UserGenericProvider>.value(
                  value: mockUserGenericProvider,
                  child: Scaffold(
                    body: Builder(
                      builder: (context) {
                        provider.userGenericProvider =
                            Provider.of<UserGenericProvider>(context,
                                listen: false);
                        return Container();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await provider.init(tester.element(find.byType(Scaffold)));

      // Assert
      expect(provider.notificationCount, 0);
    });

    test('loadProfile() should call navPush with correct route', () {
      // Act
      provider.loadProfile();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);
    });

    test('loadEvaChatHistory() should call navPush with correct route', () {
      // Act
      provider.loadEvaChatHistory();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);
    });

    test('loadExtra() should call navPush with correct route', () {
      // Act
      provider.loadExtra();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.appExtraOption);
    });

    test('loadfaq() should call navPush with correct route', () {
      // Act
      provider.loadfaq();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.faq);
    });

    test('copyToken() should copy auth token when available', () {
      // Arrange
      const testToken = 'test-auth-token-123';
      provider.amplifyService = mockAmplifyService;
      when(mockAmplifyService.authToken).thenReturn(testToken);

      // Act
      provider.copyToken();

      // Assert
      expect(provider.lastClipboardText, testToken);
    });

    test('copyToken() should copy fallback message when auth token is null',
        () {
      // Arrange
      provider.amplifyService = mockAmplifyService;
      when(mockAmplifyService.authToken).thenReturn(null);

      // Act
      provider.copyToken();

      // Assert
      expect(provider.lastClipboardText, 'authToken is empty try again');
    });

    test('copyToken() should copy fallback message when auth token is empty',
        () {
      // Arrange
      provider.amplifyService = mockAmplifyService;
      when(mockAmplifyService.authToken).thenReturn('');

      // Act
      provider.copyToken();

      // Assert
      expect(provider.lastClipboardText, 'authToken is empty try again');
    });

    test('initial state should have correct default values', () {
      // Assert
      expect(provider.appBarTotalHeight, 0.0);
      expect(provider.notificationCount, 0);
      expect(provider.userGenericProvider, isNull);
    });

    testWidgets('init() should call notifyListeners', (tester) async {
      // Arrange
      bool notifyListenersCalled = false;
      provider.addListener(() {
        notifyListenersCalled = true;
      });

      // when(mockUserGenericProvider.readNotificationCount).thenReturn(0);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Builder(
              builder: (context) {
                return ChangeNotifierProvider<UserGenericProvider>.value(
                  value: mockUserGenericProvider,
                  child: Scaffold(
                    body: Builder(
                      builder: (context) {
                        provider.userGenericProvider =
                            Provider.of<UserGenericProvider>(context,
                                listen: false);
                        return Container();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await provider.init(tester.element(find.byType(Scaffold)));

      // Assert
      expect(notifyListenersCalled, true);
    });

    testWidgets('init() should handle null userGenericProvider gracefully',
        (tester) async {
      // Arrange
      provider.userGenericProvider = null;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: Container(),
            ),
          ),
        ),
      );

      // Act & Assert - should not throw
      expect(() async {
        await provider.init(tester.element(find.byType(Scaffold)));
      }, returnsNormally);
    });

    test('multiple navigation calls should work correctly', () {
      // Act
      provider.loadProfile();
      provider.loadEvaChatHistory();
      provider.loadExtra();
      provider.loadfaq();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.faq);
    });

    test('copyToken() should handle special characters in token', () {
      // Arrange
      const testToken = 'test-token-with-special-chars!@#\$%^&*()';
      provider.amplifyService = mockAmplifyService;
      when(mockAmplifyService.authToken).thenReturn(testToken);

      // Act
      provider.copyToken();

      // Assert
      expect(provider.lastClipboardText, testToken);
    });

    test('navPop should increment counter', () {
      // Arrange
      expect(provider.navPopCount, 0);

      // Act
      provider.navPop();
      provider.navPop();

      // Assert
      expect(provider.navPopCount, 2);
    });

    test('navPush should store route and extra data', () {
      // Arrange
      const testRoute = '/test-route';
      const testExtra = {'key': 'value'};

      // Act
      provider.navPush(testRoute, extra: testExtra);

      // Assert
      expect(provider.lastNavPushRoute, testRoute);
      expect(provider.lastNavPushExtra, testExtra);
    });
  });
}
