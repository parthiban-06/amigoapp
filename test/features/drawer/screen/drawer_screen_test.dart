import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/drawer/provider/drawer_provider.dart';
import 'package:visaamigo/features/drawer/screen/drawer_screen.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/utils/responsive_util.dart';

class MockDrawerProvider extends Mock implements DrawerProvider {
  @override
  Future<void> init(BuildContext context) async {
    // Mock implementation
  }

  @override
  void loadProfile() {
    // Mock implementation
  }

  @override
  void loadEvaChatHistory() {
    // Mock implementation
  }

  @override
  void loadExtra() {
    // Mock implementation
  }

  @override
  void loadfaq() {
    // Mock implementation
  }
}

class MockUserGenericProvider extends Mock implements UserGenericProvider {
  @override
  int get readNotificationCount => 3;
}

class MockResponsiveUtil extends Mock implements ResponsiveUtil {}

void main() {
  group('DrawerScreen Widget Tests', () {
    late MockDrawerProvider mockDrawerProvider;
    late MockUserGenericProvider mockUserGenericProvider;
    late MockResponsiveUtil mockResponsiveUtil;
    late GetIt getIt;

    setUp(() {
      mockDrawerProvider = MockDrawerProvider();
      mockUserGenericProvider = MockUserGenericProvider();
      mockResponsiveUtil = MockResponsiveUtil();

      // Stub BEFORE registering or building widgets
      when(mockResponsiveUtil.kISWeb()).thenReturn(false);
      when(mockResponsiveUtil.isMobile(context: anyNamed('context')))
          .thenReturn(true);
      when(mockResponsiveUtil.isTablet(context: anyNamed('context')))
          .thenReturn(false);

      // Setup GetIt
      getIt = GetIt.instance;
      getIt.reset();

      // Register mock providers
      getIt.registerFactory<DrawerProvider>(() => mockDrawerProvider);
      getIt.registerFactoryParam<ResponsiveUtil, BuildContext, void>(
        (context, _) => mockResponsiveUtil,
      );
    });

    tearDown(() {
      getIt.reset();
    });

    testWidgets('should render drawer screen with all menu items',
        (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(3);

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DrawerProvider>.value(
              value: mockDrawerProvider,
            ),
            ChangeNotifierProvider<UserGenericProvider>.value(
              value: mockUserGenericProvider,
            ),
          ],
          child: MaterialApp(
            home: DrawerScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('EVA Chat History'), findsOneWidget);
      expect(find.text('Extra'), findsOneWidget);
      expect(find.text('FAQ'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('should call loadProfile when profile item is tapped',
        (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(0);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DrawerProvider>.value(
              value: mockDrawerProvider,
            ),
            ChangeNotifierProvider<UserGenericProvider>.value(
              value: mockUserGenericProvider,
            ),
          ],
          child: MaterialApp(
            home: DrawerScreen(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Profile'));
      await tester.pump();

      // Assert
      verify(mockDrawerProvider.loadProfile()).called(1);
    });

    testWidgets(
        'should call loadEvaChatHistory when EVA Chat History is tapped',
        (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(0);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DrawerProvider>.value(
              value: mockDrawerProvider,
            ),
            ChangeNotifierProvider<UserGenericProvider>.value(
              value: mockUserGenericProvider,
            ),
          ],
          child: MaterialApp(
            home: DrawerScreen(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('EVA Chat History'));
      await tester.pump();

      // Assert
      verify(mockDrawerProvider.loadEvaChatHistory()).called(1);
    });

    testWidgets('should call loadExtra when Extra is tapped', (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(0);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DrawerProvider>.value(
              value: mockDrawerProvider,
            ),
            ChangeNotifierProvider<UserGenericProvider>.value(
              value: mockUserGenericProvider,
            ),
          ],
          child: MaterialApp(
            home: DrawerScreen(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Extra'));
      await tester.pump();

      // Assert
      verify(mockDrawerProvider.loadExtra()).called(1);
    });

    testWidgets('should call loadfaq when FAQ is tapped', (tester) async {
      // Arrange
      // when(mockUserGenericProvider.readNotificationCount).thenReturn(0);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DrawerProvider>.value(
              value: mockDrawerProvider,
            ),
            ChangeNotifierProvider<UserGenericProvider>.value(
              value: mockUserGenericProvider,
            ),
          ],
          child: MaterialApp(
            home: DrawerScreen(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('FAQ'));
      await tester.pump();

      // Assert
      verify(mockDrawerProvider.loadfaq()).called(1);
    });
  });
}
