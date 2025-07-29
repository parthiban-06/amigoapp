import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/analytics/firebase_analytics_observer.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

class MockFirebaseAnalyticsService extends FirebaseAnalyticsService {
  String? lastRouteCalled;
  int callCount = 0;
  List<String> routeHistory = [];

  @override
  void onRouteChanged(String newRoute) {
    lastRouteCalled = newRoute;
    callCount++;
    routeHistory.add(newRoute);
  }

  void reset() {
    lastRouteCalled = null;
    callCount = 0;
    routeHistory.clear();
  }
}

void main() {
  group('FirebaseAnalyticsRouteObserver Enhanced Tests for 90% LCOV Coverage',
      () {
    late MockFirebaseAnalyticsService mockAnalyticsService;
    late FirebaseAnalyticsRouteObserver observer;

    setUp(() {
      mockAnalyticsService = MockFirebaseAnalyticsService();
      observer = FirebaseAnalyticsRouteObserver(
        analyticsListener: mockAnalyticsService,
      );
    });

    group('didPop Tests', () {
      test('should call onRouteChanged with route name when available', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '/test_route'));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/test_route');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['/test_route']);
      });

      test(
          'should call onRouteChanged with string arguments when route name is null',
          () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: '/test_route_from_args',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/test_route_from_args');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['/test_route_from_args']);
      });

      test(
          'should call onRouteChanged with runtime type when both name and string args are null',
          () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: 123, // Non-string argument
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test(
          'should call onRouteChanged with runtime type when all sources are null',
          () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: null,
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test('should handle multiple route pops correctly', () {
        // Arrange
        final route1 = MockRoute(settings: RouteSettings(name: '/route1'));
        final route2 = MockRoute(settings: RouteSettings(name: '/route2'));
        final route3 = MockRoute(settings: RouteSettings(name: '/route3'));

        // Act
        observer.didPop(route1, null);
        observer.didPop(route2, null);
        observer.didPop(route3, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/route3');
        expect(mockAnalyticsService.callCount, 3);
        expect(mockAnalyticsService.routeHistory,
            ['/route1', '/route2', '/route3']);
      });

      test('should handle route with empty name', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: ''));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['']);
      });

      test('should handle route with whitespace name', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '   '));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '   ');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['   ']);
      });

      test('should handle route with complex route name', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(name: '/user/profile/settings'),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/user/profile/settings');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['/user/profile/settings']);
      });

      test('should handle route with special characters in name', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(name: '/route-with-dashes_and_underscores'),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled,
            '/route-with-dashes_and_underscores');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory,
            ['/route-with-dashes_and_underscores']);
      });

      test('should handle route with numeric arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: '123',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '123');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['123']);
      });

      test('should handle route with object arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: {'key': 'value'},
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test('should handle route with list arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: [1, 2, 3],
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test('should handle route with boolean arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: true,
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test('should handle route with double arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: 3.14,
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test('should handle route with very long name', () {
        // Arrange
        final longRouteName = '/${'a' * 1000}';
        final route = MockRoute(settings: RouteSettings(name: longRouteName));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, longRouteName);
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, [longRouteName]);
      });

      test('should handle route with very long string arguments', () {
        // Arrange
        final longArgument = 'a' * 1000;
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: longArgument,
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, longArgument);
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, [longArgument]);
      });

      test('should handle route with unicode characters in name', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(name: '/route-with-unicode-🚀🎉🌟'),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(
            mockAnalyticsService.lastRouteCalled, '/route-with-unicode-🚀🎉🌟');
        expect(mockAnalyticsService.callCount, 1);
        expect(
            mockAnalyticsService.routeHistory, ['/route-with-unicode-🚀🎉🌟']);
      });

      test('should handle route with unicode characters in arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: 'unicode-🚀🎉🌟',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'unicode-🚀🎉🌟');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['unicode-🚀🎉🌟']);
      });

      test('should handle route with special characters in arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: 'special-chars!@#\$%^&*()',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(
            mockAnalyticsService.lastRouteCalled, 'special-chars!@#\$%^&*()');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['special-chars!@#\$%^&*()']);
      });

      test('should handle route with empty string arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: '',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['']);
      });

      test('should handle route with whitespace string arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: '   ',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '   ');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['   ']);
      });
    });

    group('Constructor Tests', () {
      test('should create observer with required analytics service', () {
        // Act & Assert
        expect(observer.analyticsListener, mockAnalyticsService);
      });

      test('should not be null when created with valid service', () {
        // Act & Assert
        expect(observer, isNotNull);
        expect(observer.analyticsListener, isNotNull);
      });

      test('should create multiple observers with different services', () {
        // Arrange
        final mockService1 = MockFirebaseAnalyticsService();
        final mockService2 = MockFirebaseAnalyticsService();

        // Act
        final observer1 =
            FirebaseAnalyticsRouteObserver(analyticsListener: mockService1);
        final observer2 =
            FirebaseAnalyticsRouteObserver(analyticsListener: mockService2);

        // Assert
        expect(observer1.analyticsListener, mockService1);
        expect(observer2.analyticsListener, mockService2);
        expect(observer1.analyticsListener, isNot(observer2.analyticsListener));
      });
    });

    group('Integration Tests', () {
      test('should work with real route scenarios', () {
        // Arrange
        final routes = [
          MockRoute(settings: RouteSettings(name: '/home')),
          MockRoute(settings: RouteSettings(name: '/profile')),
          MockRoute(settings: RouteSettings(name: '/settings')),
          MockRoute(settings: RouteSettings(name: '/logout')),
        ];

        // Act
        for (final route in routes) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/logout');
        expect(mockAnalyticsService.callCount, 4);
        expect(mockAnalyticsService.routeHistory,
            ['/home', '/profile', '/settings', '/logout']);
      });

      test('should handle mixed route scenarios', () {
        // Arrange
        final routes = [
          MockRoute(settings: RouteSettings(name: '/home')),
          MockRoute(
            settings: RouteSettings(
              name: null,
              arguments: '/profile_from_args',
            ),
          ),
          MockRoute(
            settings: RouteSettings(
              name: null,
              arguments: 123,
            ),
          ),
          MockRoute(settings: RouteSettings(name: '/settings')),
        ];

        // Act
        for (final route in routes) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/settings');
        expect(mockAnalyticsService.callCount, 4);
        expect(mockAnalyticsService.routeHistory,
            ['/home', '/profile_from_args', 'MockRoute', '/settings']);
      });

      test('should handle rapid route changes', () {
        // Arrange
        final routes = List.generate(
            10,
            (index) =>
                MockRoute(settings: RouteSettings(name: '/route$index')));

        // Act
        for (final route in routes) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/route9');
        expect(mockAnalyticsService.callCount, 10);
        expect(mockAnalyticsService.routeHistory.length, 10);
      });

      test('should handle same route multiple times', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '/same_route'));

        // Act
        for (int i = 0; i < 5; i++) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/same_route');
        expect(mockAnalyticsService.callCount, 5);
        expect(
            mockAnalyticsService.routeHistory, List.filled(5, '/same_route'));
      });
    });

    group('Edge Case Tests', () {
      test('should handle route with null settings', () {
        // Arrange
        final route = MockRoute(settings: null);

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
        expect(mockAnalyticsService.routeHistory, ['MockRoute']);
      });

      test('should handle route with null previous route', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '/test_route'));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/test_route');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle route with previous route', () {
        // Arrange
        final previousRoute =
            MockRoute(settings: RouteSettings(name: '/previous_route'));
        final currentRoute =
            MockRoute(settings: RouteSettings(name: '/current_route'));

        // Act
        observer.didPop(currentRoute, previousRoute);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/current_route');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle route with complex previous route', () {
        // Arrange
        final previousRoute = MockRoute(
          settings: RouteSettings(
            name: null,
            arguments: '/previous_from_args',
          ),
        );
        final currentRoute =
            MockRoute(settings: RouteSettings(name: '/current_route'));

        // Act
        observer.didPop(currentRoute, previousRoute);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/current_route');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle route with null previous route settings', () {
        // Arrange
        final previousRoute = MockRoute(settings: null);
        final currentRoute =
            MockRoute(settings: RouteSettings(name: '/current_route'));

        // Act
        observer.didPop(currentRoute, previousRoute);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/current_route');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle route with empty previous route name', () {
        // Arrange
        final previousRoute = MockRoute(settings: RouteSettings(name: ''));
        final currentRoute =
            MockRoute(settings: RouteSettings(name: '/current_route'));

        // Act
        observer.didPop(currentRoute, previousRoute);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/current_route');
        expect(mockAnalyticsService.callCount, 1);
      });
    });

    group('Coverage Enhancement Tests', () {
      test('should test all route name extraction scenarios', () {
        // Test various route name extraction scenarios
        final testCases = [
          RouteSettings(name: '/named_route'),
          RouteSettings(name: null, arguments: '/string_argument'),
          RouteSettings(name: null, arguments: 123),
          RouteSettings(name: null, arguments: {'key': 'value'}),
          RouteSettings(name: null, arguments: [1, 2, 3]),
          RouteSettings(name: null, arguments: true),
          RouteSettings(name: null, arguments: 3.14),
          RouteSettings(name: null, arguments: null),
          RouteSettings(name: ''),
          RouteSettings(name: '   '),
        ];

        for (int i = 0; i < testCases.length; i++) {
          // Arrange
          final route = MockRoute(settings: testCases[i]);
          mockAnalyticsService.reset();

          // Act
          observer.didPop(route, null);

          // Assert
          expect(mockAnalyticsService.callCount, 1);
          expect(mockAnalyticsService.lastRouteCalled, isNotNull);
        }
      });

      test('should test route history tracking', () {
        // Arrange
        final routes = [
          MockRoute(settings: RouteSettings(name: '/route1')),
          MockRoute(settings: RouteSettings(name: '/route2')),
          MockRoute(settings: RouteSettings(name: '/route3')),
        ];

        // Act
        for (final route in routes) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.routeHistory.length, 3);
        expect(mockAnalyticsService.routeHistory[0], '/route1');
        expect(mockAnalyticsService.routeHistory[1], '/route2');
        expect(mockAnalyticsService.routeHistory[2], '/route3');
      });

      test('should test analytics service call tracking', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '/test_route'));

        // Act
        observer.didPop(route, null);
        observer.didPop(route, null);
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.callCount, 3);
        expect(mockAnalyticsService.lastRouteCalled, '/test_route');
      });

      test('should test reset functionality', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '/test_route'));
        observer.didPop(route, null);

        // Act
        mockAnalyticsService.reset();

        // Assert
        expect(mockAnalyticsService.callCount, 0);
        expect(mockAnalyticsService.lastRouteCalled, null);
        expect(mockAnalyticsService.routeHistory, isEmpty);
      });
    });
  });
}

class MockRoute extends Route<dynamic> {
  MockRoute({required RouteSettings? settings}) : super(settings: settings);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
