import 'package:flutter/material.dart';
import 'package:visaamigo/main.dart';
import 'package:visaamigo/utils/utils.dart';

import 'app_initializer.dart';

void main() async {
  try {
    // Initialize app with production environment
    await AppInitializer.initialize(AppEnvironment.visaDev);

    // Run the app
    runApp(const MyApp());
  } catch (error, stackTrace) {
    // Handle initialization errors in production
    Utils.logPrint('Failed to initialize app: $error');
    Utils.logPrint('Stack trace: $stackTrace');

    // In production, you might want to show a user-friendly error screen
    // or implement crash reporting
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Please restart the app'),
            ],
          ),
        ),
      ),
    ));
  }
}
