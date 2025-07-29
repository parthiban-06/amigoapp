import 'package:flutter/material.dart';
import 'package:visaamigo/main.dart';
import 'package:visaamigo/utils/utils.dart';

import 'app_initializer.dart';

void main() async {
  try {
    // Initialize app with development environment
    await AppInitializer.initialize(AppEnvironment.dev);

    // Run the app
    runApp(const MyApp());
  } catch (error, stackTrace) {
    // Handle initialization errors
    Utils.logPrint('Failed to initialize app: $error');
    Utils.logPrint('Stack trace: $stackTrace');

    // You might want to show an error screen or crash gracefully
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app: $error'),
        ),
      ),
    ));
  }
}
