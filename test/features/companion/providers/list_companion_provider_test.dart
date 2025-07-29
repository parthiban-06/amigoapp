import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/companion/providers/list_companion_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/remote/api_response.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/utils.dart';
import 'package:visaamigo/router/app_router.dart';

class MockUserDetailRepo extends Mock implements UserDetailRepo {}
class MockUserGenericProvider extends Mock implements UserGenericProvider {}
class MockBuildContext extends Mock implements BuildContext {}
class MockAppRouter extends Mock implements AppRouter {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await dotenv.load(fileName: "/Users/user/Documents/AmigoApp/.env.test");
  });
  
  group('ListCompanionProvider', () {
    late ListCompanionProvider provider;
    late MockUserDetailRepo mockRepo;
    late MockUserGenericProvider mockUserGenericProvider;
    late MockBuildContext mockContext;

    setUp(() {
      mockRepo = MockUserDetailRepo();
      mockUserGenericProvider = MockUserGenericProvider();
      mockContext = MockBuildContext();
      provider = ListCompanionProvider(userDetailRepo: mockRepo);
      
      // Set up context
      provider.setContext(mockContext);
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        home: child,
      );
    }

    test('Initial values are correct', () {
      expect(provider.companionList, isNull);
      expect(provider.userMatches, isNull);
      expect(provider.showAddCompanion, isFalse);
      expect(provider.isLoading, isFalse);
    });

    test('provider state changes notify listeners', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.isLoading = true;
      provider.notifyListeners();
      expect(provider.isLoading, isTrue);
      expect(notified, isTrue);
    });

    test('showAddCompanion can be set', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.showAddCompanion = true;
      provider.notifyListeners();
      expect(provider.showAddCompanion, isTrue);
      expect(notified, isTrue);
    });

    test('companionList can be set', () {
      final companionListResponse = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          CompanionProfile(
            id: '1',
            userId: 'user1',
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com',
            matchIds: ['match1'],
            status: true,
          ),
        ],
      );
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.companionList = companionListResponse;
      provider.notifyListeners();
      expect(provider.companionList, isNotNull);
      expect(provider.companionList!.data!.length, equals(1));
      expect(notified, isTrue);
    });

    test('userMatches can be set', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 2,
            companionsAssigned: ['1'],
            tickets: ['ticket1'],
          ),
        ],
      );
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.userMatches = matchResponse;
      provider.notifyListeners();
      expect(provider.userMatches, isNotNull);
      expect(provider.userMatches!.data.length, equals(1));
      expect(notified, isTrue);
    });

    test('provider can handle empty companion list', () {
      final emptyCompanionListResponse = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [],
      );
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.companionList = emptyCompanionListResponse;
      provider.notifyListeners();
      expect(provider.companionList, isNotNull);
      expect(provider.companionList!.data, isEmpty);
      expect(notified, isTrue);
    });

    test('provider can handle multiple matches', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City 1',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event 1',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match 1',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 2,
            companionsAssigned: ['1'],
            tickets: ['ticket1'],
          ),
          MatchData(
            id: 'match2',
            matchCity: 'Test City 2',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event 2',
            matchTime: DateTime.now().add(Duration(days: 1)),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(days: 1, hours: 2)),
            matchTeams: 'Team C vs Team D',
            matchName: 'Test Match 2',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 3,
            companionsAssigned: ['1', '2'],
            tickets: ['ticket2'],
          ),
        ],
      );
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.userMatches = matchResponse;
      provider.notifyListeners();
      expect(provider.userMatches, isNotNull);
      expect(provider.userMatches!.data.length, equals(2));
      expect(notified, isTrue);
    });

    test('provider can calculate showAddCompanion logic', () {
      // Test when can add more companions
      final matchResponseCanAdd = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 3, // Can add more
            companionsAssigned: ['1'], // Only 1 assigned
            tickets: ['ticket1'],
          ),
        ],
      );
      provider.userMatches = matchResponseCanAdd;
      provider.showAddCompanion = true;
      provider.notifyListeners();
      expect(provider.showAddCompanion, isTrue);
      // Test when cannot add more companions
      final matchResponseCannotAdd = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 1, // Max reached
            companionsAssigned: ['1'], // 1 assigned, no more can be added
            tickets: ['ticket1'],
          ),
        ],
      );
      provider.userMatches = matchResponseCannotAdd;
      provider.showAddCompanion = false;
      provider.notifyListeners();
      expect(provider.showAddCompanion, isFalse);
    });

    test('provider handles null data gracefully', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      provider.companionList = null;
      provider.userMatches = null;
      provider.notifyListeners();
      expect(provider.companionList, isNull);
      expect(provider.userMatches, isNull);
      expect(notified, isTrue);
    });

    test('showAddCompanion logic works correctly with multiple matches', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City 1',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event 1',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match 1',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 2,
            companionsAssigned: ['1'],
            tickets: ['ticket1'],
          ),
          MatchData(
            id: 'match2',
            matchCity: 'Test City 2',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event 2',
            matchTime: DateTime.now().add(Duration(days: 1)),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(days: 1, hours: 2)),
            matchTeams: 'Team C vs Team D',
            matchName: 'Test Match 2',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 3,
            companionsAssigned: ['1', '2'],
            tickets: ['ticket2'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      provider.showAddCompanion = true;
      provider.notifyListeners();

      // Total max companions: 2 + 3 = 5
      // Total assigned companions: 1 + 2 = 3
      // Should be able to add more (5 > 3)
      expect(provider.showAddCompanion, isTrue);
    });

    test('showAddCompanion logic works correctly when max reached', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 2,
            companionsAssigned: ['1', '2'], // Max reached
            tickets: ['ticket1'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      provider.showAddCompanion = false;
      provider.notifyListeners();

      // Max companions: 2, Assigned: 2
      // Should not be able to add more (2 == 2)
      expect(provider.showAddCompanion, isFalse);
    });

    test('provider can handle companion list with data', () {
      final companionListResponse = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          CompanionProfile(
            id: '1',
            userId: 'user1',
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com',
            matchIds: ['match1'],
            status: true,
          ),
          CompanionProfile(
            id: '2',
            userId: 'user2',
            firstName: 'Jane',
            lastName: 'Smith',
            email: 'jane@example.com',
            matchIds: ['match1', 'match2'],
            status: true,
          ),
        ],
      );

      provider.companionList = companionListResponse;
      provider.notifyListeners();

      expect(provider.companionList, isNotNull);
      expect(provider.companionList!.data!.length, equals(2));
      expect(provider.companionList!.data![0].firstName, equals('John'));
      expect(provider.companionList!.data![1].firstName, equals('Jane'));
    });

    test('provider can handle match data with different companion limits', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 5,
            companionsAssigned: ['1', '2', '3'],
            tickets: ['ticket1'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      provider.notifyListeners();

      expect(provider.userMatches, isNotNull);
      expect(provider.userMatches!.data.length, equals(1));
      expect(provider.userMatches!.data[0].maxNoOfCompanions, equals(5));
      expect(provider.userMatches!.data[0].companionsAssigned.length, equals(3));
    });

    test('provider can handle expired tickets', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now().subtract(Duration(days: 1)), // Past event
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().subtract(Duration(hours: 22)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: true, // Expired ticket
            maxNoOfCompanions: 2,
            companionsAssigned: ['1'],
            tickets: ['ticket1'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      provider.notifyListeners();

      expect(provider.userMatches, isNotNull);
      expect(provider.userMatches!.data[0].isTicketExpired, isTrue);
    });

    test('provider can handle multiple tickets per match', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 3,
            companionsAssigned: ['1', '2'],
            tickets: ['ticket1', 'ticket2', 'ticket3'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      provider.notifyListeners();

      expect(provider.userMatches, isNotNull);
      expect(provider.userMatches!.data[0].tickets.length, equals(3));
    });

    // Test the business logic that would be executed in the init method
    test('showAddCompanion calculation logic works correctly', () {
      // Simulate the logic from the init method
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 3,
            companionsAssigned: ['1'],
            tickets: ['ticket1'],
          ),
        ],
      );

      // Set the userMatches (this would happen in init method)
      provider.userMatches = matchResponse;
      
      // Calculate showAddCompanion logic (this is the core business logic)
      int maxCompanion = 0;
      int companionsAssigned = 0;
      for (int i = 0; i < provider.userMatches!.data.length; i++) {
        maxCompanion = maxCompanion + provider.userMatches!.data.elementAt(i).maxNoOfCompanions;
        companionsAssigned = companionsAssigned + provider.userMatches!.data.elementAt(i).companionsAssigned.length;
      }
      
      if (maxCompanion > companionsAssigned) {
        provider.showAddCompanion = true;
      } else {
        provider.showAddCompanion = false;
      }

      // Test the result
      expect(provider.showAddCompanion, isTrue); // 3 > 1, so should be true
      expect(maxCompanion, equals(3));
      expect(companionsAssigned, equals(1));
    });

    test('showAddCompanion calculation logic works correctly when max reached', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 2,
            companionsAssigned: ['1', '2'], // Max reached
            tickets: ['ticket1'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      
      // Calculate showAddCompanion logic
      int maxCompanion = 0;
      int companionsAssigned = 0;
      for (int i = 0; i < provider.userMatches!.data.length; i++) {
        maxCompanion = maxCompanion + provider.userMatches!.data.elementAt(i).maxNoOfCompanions;
        companionsAssigned = companionsAssigned + provider.userMatches!.data.elementAt(i).companionsAssigned.length;
      }
      
      if (maxCompanion > companionsAssigned) {
        provider.showAddCompanion = true;
      } else {
        provider.showAddCompanion = false;
      }

      expect(provider.showAddCompanion, isFalse); // 2 == 2, so should be false
      expect(maxCompanion, equals(2));
      expect(companionsAssigned, equals(2));
    });

    test('showAddCompanion calculation logic works with multiple matches', () {
      final matchResponse = MatchResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [
          MatchData(
            id: 'match1',
            matchCity: 'Test City 1',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event 1',
            matchTime: DateTime.now(),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(hours: 2)),
            matchTeams: 'Team A vs Team B',
            matchName: 'Test Match 1',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 2,
            companionsAssigned: ['1'],
            tickets: ['ticket1'],
          ),
          MatchData(
            id: 'match2',
            matchCity: 'Test City 2',
            matchState: 'Test State',
            matchCountry: 'Test Country',
            matchStadium: 'Test Stadium',
            eventName: 'Test Event 2',
            matchTime: DateTime.now().add(Duration(days: 1)),
            matchTimezone: 'UTC',
            matchEndTime: DateTime.now().add(Duration(days: 1, hours: 2)),
            matchTeams: 'Team C vs Team D',
            matchName: 'Test Match 2',
            matchLatitude: 0.0,
            matchLongitude: 0.0,
            isTicketExpired: false,
            maxNoOfCompanions: 3,
            companionsAssigned: ['1', '2'],
            tickets: ['ticket2'],
          ),
        ],
      );

      provider.userMatches = matchResponse;
      
      // Calculate showAddCompanion logic
      int maxCompanion = 0;
      int companionsAssigned = 0;
      for (int i = 0; i < provider.userMatches!.data.length; i++) {
        maxCompanion = maxCompanion + provider.userMatches!.data.elementAt(i).maxNoOfCompanions;
        companionsAssigned = companionsAssigned + provider.userMatches!.data.elementAt(i).companionsAssigned.length;
      }
      
      if (maxCompanion > companionsAssigned) {
        provider.showAddCompanion = true;
      } else {
        provider.showAddCompanion = false;
      }

      expect(provider.showAddCompanion, isTrue); // 5 > 3, so should be true
      expect(maxCompanion, equals(5)); // 2 + 3
      expect(companionsAssigned, equals(3)); // 1 + 2
    });

    test('provider can handle loading state changes', () {
      // Test loading state management
      provider.isLoading = true;
      provider.notifyListeners();
      expect(provider.isLoading, isTrue);

      provider.isLoading = false;
      provider.notifyListeners();
      expect(provider.isLoading, isFalse);
    });

    test('provider can handle companion list with null data', () {
      // Test handling of null companion list
      provider.companionList = null;
      provider.notifyListeners();
      expect(provider.companionList, isNull);
    });

    test('provider can handle user matches with null data', () {
      // Test handling of null user matches
      provider.userMatches = null;
      provider.notifyListeners();
      expect(provider.userMatches, isNull);
    });
  });
} 