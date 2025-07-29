// test/helpers/context_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class ContextHelper {
  static Future<BuildContext> createTestContext(WidgetTester tester) async {
    late BuildContext testContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return Container();
          },
        ),
      ),
    );

    return testContext;
  }

  static Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  static Widget wrapWithProvider<T extends ChangeNotifier>(
    T provider,
    Widget child,
  ) {
    return ChangeNotifierProvider<T>.value(
      value: provider,
      child: wrapWithMaterialApp(child),
    );
  }
}
