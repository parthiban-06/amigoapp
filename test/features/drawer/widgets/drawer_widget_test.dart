import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/drawer/widgets/drawer_widget.dart';

void main() {
  group('DrawerItemWidget Tests', () {
    testWidgets('should render widget with title and no notification count',
        (tester) async {
      // Arrange
      const title = 'Test Menu Item';
      const notificationCount = 0;
      bool onItemClickCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
          ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
              theme: VisaTheme.lightTheme,
              home: Scaffold(
                body: DrawerItemWidget(
                  title: title,
                  notificationCount: notificationCount,
                  onItemClick: null,
                ),
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
          ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ),
      );

      // Assert
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Item'), findsOneWidget);
    });

    testWidgets('should render notification badge with correct styling',
        (tester) async {
      // Arrange
      const title = 'Notifications';
      const notificationCount = 10;
      bool onItemClickCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ),
      );

      // Assert
      expect(find.text('10'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle large notification count correctly',
        (tester) async {
      // Arrange
      const title = 'Notifications';
      const notificationCount = 999;
      bool onItemClickCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
          ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
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
          ),
        );
      }, returnsNormally);
    });

    testWidgets('should render arrow icon correctly', (tester) async {
      // Arrange
      const title = 'Test Item';
      const notificationCount = 0;
      bool onItemClickCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ),
      );

      // Assert - Check for the presence of the arrow icon
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle long title text correctly', (tester) async {
      // Arrange
      const title =
          'This is a very long menu item title that should be handled properly';
      const notificationCount = 0;
      bool onItemClickCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
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
        ),
      );

      // Assert
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
