import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/analytics/firebase_analytics_observer.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

class MockFirebaseAnalyticsService extends FirebaseAnalyticsService {
  String? lastRouteCalled;
  int callCount = 0;

  @override
  void onRouteChanged(String newRoute) {
    lastRouteCalled = newRoute;
    callCount++;
  }
}

void main() {
  group('FirebaseAnalyticsRouteObserver Tests', () {
    late MockFirebaseAnalyticsService mockAnalyticsService;
    late FirebaseAnalyticsRouteObserver observer;

    setUp(() {
      mockAnalyticsService = MockFirebaseAnalyticsService();
      observer = FirebaseAnalyticsRouteObserver(
        analyticsListener: mockAnalyticsService,
      );
    });

    group('didPop', () {
      test('should call onRouteChanged with route name when available', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '/test_route'));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/test_route');
        expect(mockAnalyticsService.callCount, 1);
      });

      test(
          'should call onRouteChanged with string arguments when route name is null',
          () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: "",
            arguments: '/test_route_from_args',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/test_route_from_args');
        expect(mockAnalyticsService.callCount, 1);
      });

      test(
          'should call onRouteChanged with runtime type when both name and string args are null',
          () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: "",
            arguments: 123, // Non-string argument
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
      });

      test(
          'should call onRouteChanged with empty string when all sources are null',
          () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: "",
            arguments: null,
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle multiple route pops correctly', () {
        // Arrange
        final route1 = MockRoute(settings: RouteSettings(name: '/route1'));
        final route2 = MockRoute(settings: RouteSettings(name: '/route2'));

        // Act
        observer.didPop(route1, null);
        observer.didPop(route2, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/route2');
        expect(mockAnalyticsService.callCount, 2);
      });

      test('should handle route with empty name', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: ''));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle route with whitespace name', () {
        // Arrange
        final route = MockRoute(settings: RouteSettings(name: '   '));

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '   ');
        expect(mockAnalyticsService.callCount, 1);
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
      });

      test('should handle route with numeric arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: "",
            arguments: '123',
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '123');
        expect(mockAnalyticsService.callCount, 1);
      });

      test('should handle route with object arguments', () {
        // Arrange
        final route = MockRoute(
          settings: RouteSettings(
            name: "",
            arguments: {'key': 'value'},
          ),
        );

        // Act
        observer.didPop(route, null);

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 1);
      });
    });

    group('Constructor', () {
      test('should create observer with required analytics service', () {
        // Act & Assert
        expect(observer.analyticsListener, mockAnalyticsService);
      });

      test('should not be null when created with valid service', () {
        // Act & Assert
        expect(observer, isNotNull);
        expect(observer.analyticsListener, isNotNull);
      });
    });

    group('Integration', () {
      test('should work with real route scenarios', () {
        // Arrange
        final routes = [
          MockRoute(settings: RouteSettings(name: '/home')),
          MockRoute(settings: RouteSettings(name: '/profile')),
          MockRoute(settings: RouteSettings(name: '/settings')),
        ];

        // Act
        for (final route in routes) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, '/settings');
        expect(mockAnalyticsService.callCount, 3);
      });

      test('should handle mixed route scenarios', () {
        // Arrange
        final routes = [
          MockRoute(settings: RouteSettings(name: '/home')),
          MockRoute(
            settings: RouteSettings(
              name: "",
              arguments: '/profile_from_args',
            ),
          ),
          MockRoute(
            settings: RouteSettings(
              name: "",
              arguments: 123,
            ),
          ),
        ];

        // Act
        for (final route in routes) {
          observer.didPop(route, null);
        }

        // Assert
        expect(mockAnalyticsService.lastRouteCalled, 'MockRoute');
        expect(mockAnalyticsService.callCount, 3);
      });
    });
  });
}

class MockRoute extends Route<dynamic> {
  MockRoute({required RouteSettings settings}) : super(settings: settings);

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
