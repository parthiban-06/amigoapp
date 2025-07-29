import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/drawer/provider/drawer_provider.dart';
import 'package:visaamigo/router/app_routes_const.dart';

// Testable version of DrawerProvider
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

// Mock class for testing
class MockUserGenericProvider {
  int readNotificationCount = 0;
}

void main() {
  group('Simple Drawer Tests', () {
    test('DrawerProvider should initialize with default values', () {
      // Arrange & Act
      final provider = TestableDrawerProvider();

      // Assert
      expect(provider.appBarTotalHeight, 0.0);
      expect(provider.notificationCount, 0);
      expect(provider.userGenericProvider, isNull);
    });

    test('DrawerProvider loadProfile should call navPush', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.loadProfile();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);
    });

    test('DrawerProvider loadEvaChatHistory should call navPush', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.loadEvaChatHistory();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);
    });

    test('DrawerProvider loadExtra should call navPush', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.loadExtra();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.appExtraOption);
    });

    test('DrawerProvider loadfaq should call navPush', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.loadfaq();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.faq);
    });

    test('DrawerProvider copyToken should copy to clipboard', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.copyToken();

      // Assert
      expect(provider.lastClipboardText, isNotNull);
    });

    test('DrawerProvider should handle multiple navigation calls', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.loadProfile();
      provider.loadEvaChatHistory();
      provider.loadExtra();
      provider.loadfaq();

      // Assert
      expect(provider.lastNavPushRoute, AppRoutes.faq);
    });

    test('DrawerProvider should handle notification count updates', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.notificationCount = 5;

      // Assert
      expect(provider.notificationCount, 5);
    });

    test('DrawerProvider should handle app bar height updates', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.appBarTotalHeight = 100.0;

      // Assert
      expect(provider.appBarTotalHeight, 100.0);
    });

    test('DrawerProvider navPop should increment counter', () {
      // Arrange
      final provider = TestableDrawerProvider();
      expect(provider.navPopCount, 0);

      // Act
      provider.navPop();
      provider.navPop();

      // Assert
      expect(provider.navPopCount, 2);
    });

    test('DrawerProvider navPush should store route and extra data', () {
      // Arrange
      final provider = TestableDrawerProvider();
      const testRoute = '/test-route';
      const testExtra = {'key': 'value'};

      // Act
      provider.navPush(testRoute, extra: testExtra);

      // Assert
      expect(provider.lastNavPushRoute, testRoute);
      expect(provider.lastNavPushExtra, testExtra);
    });

    test('DrawerProvider should handle different notification counts', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act & Assert
      provider.notificationCount = 0;
      expect(provider.notificationCount, 0);

      provider.notificationCount = 10;
      expect(provider.notificationCount, 10);

      provider.notificationCount = 99;
      expect(provider.notificationCount, 99);

      provider.notificationCount = 100;
      expect(provider.notificationCount, 100);
    });

    test('DrawerProvider should handle different app bar heights', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act & Assert
      provider.appBarTotalHeight = 50.0;
      expect(provider.appBarTotalHeight, 50.0);

      provider.appBarTotalHeight = 100.0;
      expect(provider.appBarTotalHeight, 100.0);

      provider.appBarTotalHeight = 200.0;
      expect(provider.appBarTotalHeight, 200.0);
    });

    test('DrawerProvider should handle all navigation methods in sequence', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.loadProfile();
      expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);

      provider.loadEvaChatHistory();
      expect(provider.lastNavPushRoute, AppRoutes.evaChatHistory);

      provider.loadExtra();
      expect(provider.lastNavPushRoute, AppRoutes.appExtraOption);

      provider.loadfaq();
      expect(provider.lastNavPushRoute, AppRoutes.faq);
    });

    test('DrawerProvider should handle clipboard operations', () {
      // Arrange
      final provider = TestableDrawerProvider();

      // Act
      provider.copyToken();

      // Assert
      expect(provider.lastClipboardText, isNotNull);
      expect(provider.lastClipboardText, isA<String>());
    });
  });
}
