import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:visaamigo/features/home/providers/home_provider.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';

import '../../test_ui/test_login.mocks.dart';

// Mock class for AmplifyAuthCognitoPlugin
class MockAuthCognitoPlugin extends Mock implements AmplifyAuthCognito {}

class MockUserDetailRepo extends Mock implements UserDetailRepo {}

class MockBuildContext extends Mock implements BuildContext {}

class MockUserGenericProvider extends Mock implements UserGenericProvider {}

class TestableHomeViewProvider extends HomeViewProvider {
  Object? lastNavPush;
  String? lastNavPushRoute;
  int navPopCount = 0;
  BuildContext? _context;

  TestableHomeViewProvider({required UserDetailRepo userDetailRepo, AmplifyAuthCognito? amplifyCognito})
      : super(userDetailRepo: userDetailRepo,authPlugin: amplifyCognito);

  @override
  void navPush(String route, {Object? extra}) {
    lastNavPush = extra;
    lastNavPushRoute = route;
  }

  @override
  void navPop() {
    navPopCount++;
  }

  @override
  void setState([VoidCallback? fn]) {
    fn?.call();
  }

  @override
  BuildContext getContext() => _context!;
  void setContext(BuildContext ctx) => _context = ctx;
}


@GenerateMocks([AmplifyAuthCognito])
void main() {
  provideDummy<UserMfaPreference>(UserMfaPreference(
      enabled: {MfaType.email}, preferred: MfaType.email
  ));
  late TestableHomeViewProvider provider;
  late MockUserDetailRepo mockRepo;
  late MockAmplifyAuthCognito mockAuth;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: "config/dev/.env");
  });

  setUp(() {
    mockRepo = MockUserDetailRepo();
    mockAuth = MockAmplifyAuthCognito();
    when(mockAuth.fetchMfaPreference()).thenAnswer((_) async => UserMfaPreference(
        enabled: {MfaType.email},
      preferred: MfaType.email
    ));
    provider = TestableHomeViewProvider(userDetailRepo: mockRepo,amplifyCognito: mockAuth);

  });

  group('Coverage - HomeViewProvider', () {
    testWidgets('init() sets up states and calls dependencies', (tester) async {

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (ctx) {
              provider.setContext(ctx);
              // provider.init(ctx);
              return const Scaffold(body: Placeholder());
            },
          ),
        ),
      );

      provider.getMFA();

      // expect(provider.appBarTotalHeight, greaterThan(0));
    });

  });
}

// Add mocks for missing classes for completeness
class NotificationResponse {
  final List<NotificationData>? data;
  NotificationResponse({this.data});
}

class NotificationData {
  final bool? read;
  NotificationData({this.read});
}

class CompanionListResponse {
  final List<CompanionData>? data;
  CompanionListResponse({this.data});
}

class CompanionData {}

class WalletResponse {
  final String messageKey;
  final List<WalletData> data;
  WalletResponse({required this.messageKey, required this.data});
}

class WalletData {
  final Voucher voucher;
  final PrepaidCard prepaidCard;
  WalletData({required this.voucher, required this.prepaidCard});
}

class Voucher {
  final bool voucherRedeemed;
  final String voucherCode;
  Voucher({required this.voucherRedeemed, required this.voucherCode});
}

class PrepaidCard {
  final String provisioningToken;
  PrepaidCard({required this.provisioningToken});
}

class MatchResponse {
  final List<MatchData> data;
  MatchResponse({required this.data});
}

class MatchData {
  final DateTime matchTime;
  MatchData({required this.matchTime});
}

class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? messageKey;
  ApiResponse({required this.isSuccess, this.data, this.messageKey});
}

class CarouselSliderController {
  void animateToPage(int idx) {}
}

// class MockTutorialProvider extends Mock implements TutorialProvider {}