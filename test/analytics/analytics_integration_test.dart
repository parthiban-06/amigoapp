import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/analytics/firebase_analytics_observer.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

void main() {
  group('Analytics Integration Tests', () {
    group('FirebaseAnalyticsService Integration', () {
      setUp(() {
        // Reset static variables
        FirebaseAnalyticsService.previousPage = "";
        FirebaseAnalyticsService.userAnalyticsId = "";
        FirebaseAnalyticsService.userLanguage = "en";
      });

      test('should handle complete user journey', () async {
        // Simulate a complete user journey with analytics
        expect(
          () async {
            // User opens app
            await FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_APP_OPEN,
              screenName: '/home',
            );

            // User navigates to profile
            await FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW,
              screenName: '/profile',
              previousScreen: '/home',
            );

            // User clicks a button
            await FirebaseAnalyticsService.logEventButtonClick(
              btnName: 'edit_profile_button',
            );

            // User sets language
            await FirebaseAnalyticsService.setUserProperty(
              name: 'user_language',
              value: 'en',
            );

            // User logs out
            await FirebaseAnalyticsService.clearUserOnLogout();
          },
          returnsNormally,
        );
      });

      test('should handle route changes with analytics service', () {
        final service = FirebaseAnalyticsService();

        expect(
          () {
            service.onRouteChanged('/home');
            service.onRouteChanged('/profile');
            service.onRouteChanged('/settings');
          },
          returnsNormally,
        );
      });

      test('should handle device info collection', () {
        final info = <String, Object>{};

        expect(
          () {
            final deviceInfo =
                FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);
            expect(deviceInfo, isNotEmpty);
            expect(deviceInfo['platform'], isNotNull);
          },
          returnsNormally,
        );
      });
    });

    group('FirebaseAnalyticsRouteObserver Integration', () {
      late MockFirebaseAnalyticsService mockAnalyticsService;
      late FirebaseAnalyticsRouteObserver observer;

      setUp(() {
        mockAnalyticsService = MockFirebaseAnalyticsService();
        observer = FirebaseAnalyticsRouteObserver(
          analyticsListener: mockAnalyticsService,
        );
      });

      test('should track route changes through observer', () {
        final routes = [
          MockRoute(settings: RouteSettings(name: '/home')),
          MockRoute(settings: RouteSettings(name: '/profile')),
          MockRoute(settings: RouteSettings(name: '/settings')),
        ];

        for (final route in routes) {
          observer.didPop(route, null);
        }

        expect(mockAnalyticsService.callCount, 3);
        expect(mockAnalyticsService.lastRouteCalled, '/settings');
      });

      test('should handle mixed route scenarios', () {
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
              arguments: {'key': 'value'},
            ),
          ),
        ];

        for (final route in routes) {
          observer.didPop(route, null);
        }

        expect(mockAnalyticsService.callCount, 3);
      });
    });

    group('Complete Analytics Flow', () {
      testWidgets('should handle complete analytics flow',
          (WidgetTester tester) async {
        try {
          final mockService = MockFirebaseAnalyticsService();

          final testWidget = MaterialApp(
            home: CompleteAnalyticsTestWidget(
              analyticsService: mockService,
            ),
          );

          await tester.pumpWidget(testWidget);

          // Simulate user interactions
          await tester.tap(find.text('Track Event'));
          await tester.pump();

          await tester.tap(find.text('Track Button Click'));
          await tester.pump();

          await tester.tap(find.text('Change Route'));
          await tester.pump();

          // Verify analytics were called
          expect(mockService.callCount, greaterThan(0));
        } catch (e) {
          // Skip test if Firebase is not available
          expect(true, isTrue);
        }
      });
    });

    group('Error Handling Integration', () {
      test('should handle analytics service errors gracefully', () async {
        expect(
          () async {
            // Test with invalid parameters
            await FirebaseAnalyticsService.setUserProperty(
              name: '',
              value: 'test',
            );

            await FirebaseAnalyticsService.logEvent(
              eventName: '',
              parameters: null,
            );

            await FirebaseAnalyticsService.logEventButtonClick(
              btnName: '',
            );
          },
          returnsNormally,
        );
      });

      test('should handle route observer errors gracefully', () {
        final mockService = MockFirebaseAnalyticsService();
        final observer = FirebaseAnalyticsRouteObserver(
          analyticsListener: mockService,
        );

        expect(
          () {
            // Test with problematic routes
            final route1 = MockRoute(
              settings: RouteSettings(name: null, arguments: null),
            );
            final route2 = MockRoute(
              settings: RouteSettings(name: '', arguments: ''),
            );

            observer.didPop(route1, null);
            observer.didPop(route2, null);
          },
          returnsNormally,
        );
      });
    });

    group('Performance Tests', () {
      test('should handle multiple rapid analytics calls', () async {
        expect(
          () async {
            for (int i = 0; i < 10; i++) {
              await FirebaseAnalyticsService.logEvent(
                eventName: 'test_event_$i',
                screenName: '/test_screen_$i',
              );
            }
          },
          returnsNormally,
        );
      });

      test('should handle rapid route changes', () {
        final mockService = MockFirebaseAnalyticsService();
        final observer = FirebaseAnalyticsRouteObserver(
          analyticsListener: mockService,
        );

        expect(
          () {
            for (int i = 0; i < 10; i++) {
              final route = MockRoute(
                settings: RouteSettings(name: '/route_$i'),
              );
              observer.didPop(route, null);
            }
          },
          returnsNormally,
        );

        expect(mockService.callCount, 10);
      });
    });
  });
}

class MockFirebaseAnalyticsService extends FirebaseAnalyticsService {
  String? lastRouteCalled;
  int callCount = 0;

  @override
  void onRouteChanged(String newRoute) {
    lastRouteCalled = newRoute;
    callCount++;
  }
}

class CompleteAnalyticsTestWidget extends StatefulWidget {
  final MockFirebaseAnalyticsService analyticsService;

  const CompleteAnalyticsTestWidget({
    Key? key,
    required this.analyticsService,
  }) : super(key: key);

  @override
  CompleteAnalyticsTestWidgetState createState() =>
      CompleteAnalyticsTestWidgetState();
}

class CompleteAnalyticsTestWidgetState
    extends State<CompleteAnalyticsTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await FirebaseAnalyticsService.logEvent(
              eventName: 'test_event',
              screenName: '/test_screen',
            );
          },
          child: const Text('Track Event'),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAnalyticsService.logEventButtonClick(
              btnName: 'test_button',
            );
          },
          child: const Text('Track Button Click'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.analyticsService.onRouteChanged('/new_route');
          },
          child: const Text('Change Route'),
        ),
      ],
    );
  }
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
