import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/utils/connectivity_service.dart';

import 'connectivity_service_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late MockConnectivity mockConnectivity;
  late ConnectivityService connectivityService;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockConnectivity = MockConnectivity();
    connectivityService = ConnectivityService()
      ..connectivity = mockConnectivity;
  });

  group('ConnectivityService', () {
    testWidgets('should show bottom sheet when there is no internet',
        (WidgetTester tester) async {
      // Arrange
      final streamController = StreamController<List<ConnectivityResult>>();
      when(mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => streamController.stream);

      bool modalShown = false;

      final testWidget = MaterialApp(
        home: Builder(
          builder: (context) {
            connectivityService.checkConnectivity(
              context,
              onShowModal: () => modalShown = true,
            );
            return const SizedBox();
          },
        ),
      );

      await tester.pumpWidget(testWidget);

      // Act: Simulate no internet
      streamController.add([ConnectivityResult.none]);
      await tester.pumpAndSettle();

      // Assert
      expect(modalShown, isTrue);

      // Clean up
      await streamController.close();
    });

    testWidgets('should not show bottom sheet if internet is connected',
        (WidgetTester tester) async {
      final streamController = StreamController<List<ConnectivityResult>>();
      when(mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => streamController.stream);

      bool modalShown = false;

      final testWidget = MaterialApp(
        home: Builder(
          builder: (context) {
            connectivityService.checkConnectivity(
              context,
              onShowModal: () => modalShown = true,
            );
            return const SizedBox();
          },
        ),
      );

      await tester.pumpWidget(testWidget);

      // Simulate internet available
      streamController.add([ConnectivityResult.wifi]);
      await tester.pumpAndSettle();

      expect(modalShown, isFalse);

      await streamController.close();
    });

    test('should return true for real internet connection', () async {
      final result = await connectivityService.hasRealInternetConnection();
      expect(result, isTrue);
    });
  });
}
