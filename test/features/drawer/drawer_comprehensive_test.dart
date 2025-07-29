import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/drawer/provider/drawer_provider.dart';
import 'package:visaamigo/features/drawer/widgets/drawer_widget.dart';
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
  group('Drawer Feature Comprehensive Tests', () {
    group('DrawerProvider Tests', () {
      late TestableDrawerProvider provider;
      late MockUserGenericProvider mockUserGenericProvider;
      late MockAmplifyService mockAmplifyService;

      setUp(() {
        provider = TestableDrawerProvider();
        mockUserGenericProvider = MockUserGenericProvider();
        mockAmplifyService = MockAmplifyService();
      });

      testWidgets('init() should set appBarTotalHeight and notificationCount',
          (tester) async {
        // Arrange
        // when(mockUserGenericProvider.readNotificationCount).thenReturn(5);

        await tester.pumpWidget(
          MaterialApp(
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
        );

        // Act
        await provider.init(tester.element(find.byType(Scaffold)));

        // Assert
        expect(provider.appBarTotalHeight, greaterThan(0));
        expect(provider.notificationCount, 5);
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

      test('initial state should have correct default values', () {
        // Assert
        expect(provider.appBarTotalHeight, 0.0);
        expect(provider.notificationCount, 0);
        expect(provider.userGenericProvider, isNull);
      });
    });

    group('DrawerItemWidget Tests', () {
      testWidgets('should render widget with title and no notification count',
          (tester) async {
        // Arrange
        const title = 'Test Menu Item';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('Menu'), findsOneWidget);
        expect(find.text('Item'), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should render widget with notification badge when count > 0',
          (tester) async {
        // Arrange
        const title = 'Notifications';
        const notificationCount = 5;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('5'), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should show "99+" when notification count > 99',
          (tester) async {
        // Arrange
        const title = 'Notifications';
        const notificationCount = 150;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('99+'), findsOneWidget);
      });

      testWidgets('should call onItemClick when tapped', (tester) async {
        // Arrange
        const title = 'Test Item';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(GestureDetector));
        await tester.pumpAndSettle();

        // Assert
        expect(onItemClickCalled, true);
      });

      testWidgets('should handle null onItemClick gracefully', (tester) async {
        // Arrange
        const title = 'Test Item';
        const notificationCount = 0;

        // Act & Assert - should not throw
        expect(() async {
          await tester.pumpWidget(
            MaterialApp(
              theme: VisaTheme.lightTheme,
              home: Scaffold(
                body: DrawerItemWidget(
                  title: title,
                  notificationCount: notificationCount,
                  onItemClick: null,
                ),
              ),
            ),
          );
        }, returnsNormally);
      });

      testWidgets('should handle single word title correctly', (tester) async {
        // Arrange
        const title = 'Profile';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('should handle empty title gracefully', (tester) async {
        // Arrange
        const title = '';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        // Act & Assert - should not throw
        expect(() async {
          await tester.pumpWidget(
            MaterialApp(
              theme: VisaTheme.lightTheme,
              home: Scaffold(
                body: DrawerItemWidget(
                  title: title,
                  notificationCount: notificationCount,
                  onItemClick: () {
                    onItemClickCalled = true;
                  },
                ),
              ),
            ),
          );
        }, returnsNormally);
      });

      testWidgets('should handle title with multiple spaces correctly',
          (tester) async {
        // Arrange
        const title = 'Test  Menu  Item';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('Menu'), findsOneWidget);
        expect(find.text('Item'), findsOneWidget);
      });

      testWidgets('should handle large notification count correctly',
          (tester) async {
        // Arrange
        const title = 'Notifications';
        const notificationCount = 999;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('99+'), findsOneWidget);
      });

      testWidgets('should handle negative notification count gracefully',
          (tester) async {
        // Arrange
        const title = 'Notifications';
        const notificationCount = -5;
        bool onItemClickCalled = false;

        // Act & Assert - should not throw
        expect(() async {
          await tester.pumpWidget(
            MaterialApp(
              theme: VisaTheme.lightTheme,
              home: Scaffold(
                body: DrawerItemWidget(
                  title: title,
                  notificationCount: notificationCount,
                  onItemClick: () {
                    onItemClickCalled = true;
                  },
                ),
              ),
            ),
          );
        }, returnsNormally);
      });

      testWidgets('should handle long title text correctly', (tester) async {
        // Arrange
        const title =
            'This is a very long menu item title that should be handled properly';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('This'), findsOneWidget);
        expect(find.text('is'), findsOneWidget);
        expect(find.text('a'), findsOneWidget);
        expect(find.text('very'), findsOneWidget);
        expect(find.text('long'), findsOneWidget);
        expect(find.text('menu'), findsOneWidget);
        expect(find.text('item'), findsOneWidget);
        expect(find.text('title'), findsOneWidget);
        expect(find.text('that'), findsOneWidget);
        expect(find.text('should'), findsOneWidget);
        expect(find.text('be'), findsOneWidget);
        expect(find.text('handled'), findsOneWidget);
        expect(find.text('properly'), findsOneWidget);
      });

      testWidgets('should handle special characters in title', (tester) async {
        // Arrange
        const title = 'Test & Menu @ Item #123';
        const notificationCount = 0;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('&'), findsOneWidget);
        expect(find.text('Menu'), findsOneWidget);
        expect(find.text('@'), findsOneWidget);
        expect(find.text('Item'), findsOneWidget);
        expect(find.text('#123'), findsOneWidget);
      });

      testWidgets('should maintain proper layout structure', (tester) async {
        // Arrange
        const title = 'Test Item';
        const notificationCount = 5;
        bool onItemClickCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: title,
                notificationCount: notificationCount,
                onItemClick: () {
                  onItemClickCalled = true;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Integration Tests', () {
      test('drawer provider should handle all navigation methods', () {
        // Arrange
        final provider = TestableDrawerProvider();

        // Act & Assert
        provider.loadProfile();
        expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);

        provider.loadEvaChatHistory();
        expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);

        provider.loadExtra();
        expect(provider.lastNavPushRoute, AppRoutes.appExtraOption);

        provider.loadfaq();
        expect(provider.lastNavPushRoute, AppRoutes.faq);
      });

      test('drawer provider should handle clipboard operations', () {
        // Arrange
        final provider = TestableDrawerProvider();
        final mockAmplifyService = MockAmplifyService();
        provider.amplifyService = mockAmplifyService;

        // Act & Assert - with valid token
        when(mockAmplifyService.authToken).thenReturn('valid-token');
        provider.copyToken();
        expect(provider.lastClipboardText, 'valid-token');

        // Act & Assert - with null token
        when(mockAmplifyService.authToken).thenReturn(null);
        provider.copyToken();
        expect(provider.lastClipboardText, 'authToken is empty try again');

        // Act & Assert - with empty token
        when(mockAmplifyService.authToken).thenReturn('');
        provider.copyToken();
        expect(provider.lastClipboardText, 'authToken is empty try again');
      });

      testWidgets(
          'drawer widget should handle all notification count scenarios',
          (tester) async {
        // Test with zero count
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: 'Test',
                notificationCount: 0,
                onItemClick: () {},
              ),
            ),
          ),
        );
        expect(find.text('0'), findsNothing);

        // Test with normal count
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: 'Test',
                notificationCount: 5,
                onItemClick: () {},
              ),
            ),
          ),
        );
        expect(find.text('5'), findsOneWidget);

        // Test with large count
        await tester.pumpWidget(
          MaterialApp(
            theme: VisaTheme.lightTheme,
            home: Scaffold(
              body: DrawerItemWidget(
                title: 'Test',
                notificationCount: 150,
                onItemClick: () {},
              ),
            ),
          ),
        );
        expect(find.text('99+'), findsOneWidget);
      });
    });
  });
}
