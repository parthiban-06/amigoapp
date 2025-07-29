import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';

void main() {
  group('CompanionListResponse', () {
    test('should create CompanionListResponse instance with all parameters', () {
      final response = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [],
      );

      expect(response.statusCode, equals(200));
      expect(response.messageKey, equals('success'));
      expect(response.data, equals([]));
    });

    test('should create CompanionListResponse instance with null data', () {
      final response = CompanionListResponse(
        statusCode: 404,
        messageKey: 'not_found',
        data: null,
      );

      expect(response.statusCode, equals(404));
      expect(response.messageKey, equals('not_found'));
      expect(response.data, isNull);
    });

    test('should create CompanionListResponse from JSON with data', () {
      final json = {
        'status_code': 200,
        'message_key': 'success',
        'data': [
          {
            'id': '1',
            'user_id': 'user1',
            'first_name': 'John',
            'last_name': 'Doe',
            'email': 'john.doe@example.com',
            'match_ids': ['match1', 'match2'],
            'status': true,
          },
        ],
      };

      final response = CompanionListResponse.fromJson(json);

      expect(response.statusCode, equals(200));
      expect(response.messageKey, equals('success'));
      expect(response.data, isNotNull);
      expect(response.data!.length, equals(1));
      expect(response.data!.first.firstName, equals(''));
      expect(response.data!.first.lastName, equals(''));
    });

    test('should create CompanionListResponse from JSON with null data', () {
      final json = {
        'status_code': 404,
        'message_key': 'not_found',
        'data': null,
      };

      final response = CompanionListResponse.fromJson(json);

      expect(response.statusCode, equals(404));
      expect(response.messageKey, equals('not_found'));
      expect(response.data, isNull);
    });

    test('should create CompanionListResponse from JSON with empty data list', () {
      final json = {
        'status_code': 200,
        'message_key': 'success',
        'data': [],
      };

      final response = CompanionListResponse.fromJson(json);

      expect(response.statusCode, equals(200));
      expect(response.messageKey, equals('success'));
      expect(response.data, isEmpty);
    });

    test('should convert CompanionListResponse to JSON with data', () {
      final companion = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@example.com',
        matchIds: ['match1'],
        status: true,
      );

      final response = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [companion],
      );

      final json = response.toJson();

      expect(json['status_code'], equals(200));
      expect(json['message_key'], equals('success'));
      expect(json['data'], isNotNull);
      expect(json['data'].length, equals(1));
      expect(json['data'][0]['first_name'], equals('Jane'));
    });

    test('should convert CompanionListResponse to JSON with null data', () {
      final response = CompanionListResponse(
        statusCode: 404,
        messageKey: 'not_found',
        data: null,
      );

      final json = response.toJson();

      expect(json['status_code'], equals(404));
      expect(json['message_key'], equals('not_found'));
      expect(json.containsKey('data'), isFalse);
    });

    test('should convert CompanionListResponse to JSON with empty data list', () {
      final response = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: [],
      );

      final json = response.toJson();

      expect(json['status_code'], equals(200));
      expect(json['message_key'], equals('success'));
      expect(json['data'], isEmpty);
    });
  });

  group('CompanionProfile', () {
    test('should create CompanionProfile instance with all parameters', () {
      final profile = CompanionProfile(
        id: '1',
        userId: 'user1',
        firstName: 'Alice',
        lastName: 'Johnson',
        email: 'alice.johnson@example.com',
        matchIds: ['match1', 'match2'],
        status: true,
      );

      expect(profile.id, equals('1'));
      expect(profile.userId, equals('user1'));
      expect(profile.firstName, equals('Alice'));
      expect(profile.lastName, equals('Johnson'));
      expect(profile.email, equals('alice.johnson@example.com'));
      expect(profile.matchIds, equals(['match1', 'match2']));
      expect(profile.status, isTrue);
    });

    test('should create CompanionProfile instance with empty matchIds', () {
      final profile = CompanionProfile(
        id: '2',
        userId: 'user2',
        firstName: 'Bob',
        lastName: 'Wilson',
        email: 'bob.wilson@example.com',
        matchIds: [],
        status: false,
      );

      expect(profile.id, equals('2'));
      expect(profile.userId, equals('user2'));
      expect(profile.firstName, equals('Bob'));
      expect(profile.lastName, equals('Wilson'));
      expect(profile.email, equals('bob.wilson@example.com'));
      expect(profile.matchIds, isEmpty);
      expect(profile.status, isFalse);
    });

    test('should create CompanionProfile from JSON with all fields', () {
      final json = {
        'id': '3',
        'user_id': 'user3',
        'first_name': 'Charlie',
        'last_name': 'Brown',
        'email': 'charlie.brown@example.com',
        'match_ids': ['match3', 'match4', 'match5'],
        'status': true,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.id, equals('3'));
      expect(profile.userId, equals('user3'));
      expect(profile.firstName, equals(''));
      expect(profile.lastName, equals(''));
      expect(profile.email, equals('charlie.brown@example.com'));
      expect(profile.matchIds, equals(['match3', 'match4', 'match5']));
      expect(profile.status, isTrue);
    });

    test('should create CompanionProfile from JSON with null match_ids', () {
      final json = {
        'id': '4',
        'user_id': 'user4',
        'first_name': 'David',
        'last_name': 'Miller',
        'email': 'david.miller@example.com',
        'match_ids': null,
        'status': false,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.id, equals('4'));
      expect(profile.userId, equals('user4'));
      expect(profile.firstName, equals(''));
      expect(profile.lastName, equals(''));
      expect(profile.email, equals('david.miller@example.com'));
      expect(profile.matchIds, isEmpty);
      expect(profile.status, isFalse);
    });

    test('should create CompanionProfile from JSON with missing match_ids', () {
      final json = {
        'id': '5',
        'user_id': 'user5',
        'first_name': 'Eva',
        'last_name': 'Davis',
        'email': 'eva.davis@example.com',
        'status': true,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.id, equals('5'));
      expect(profile.userId, equals('user5'));
      expect(profile.firstName, equals(''));
      expect(profile.lastName, equals(''));
      expect(profile.email, equals('eva.davis@example.com'));
      expect(profile.matchIds, isEmpty);
      expect(profile.status, isTrue);
    });

    test('should create CompanionProfile from JSON with empty match_ids array', () {
      final json = {
        'id': '6',
        'user_id': 'user6',
        'first_name': 'Frank',
        'last_name': 'Garcia',
        'email': 'frank.garcia@example.com',
        'match_ids': [],
        'status': false,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.id, equals('6'));
      expect(profile.userId, equals('user6'));
      expect(profile.firstName, equals(''));
      expect(profile.lastName, equals(''));
      expect(profile.email, equals('frank.garcia@example.com'));
      expect(profile.matchIds, isEmpty);
      expect(profile.status, isFalse);
    });

    test('should convert CompanionProfile to JSON with all fields', () {
      final profile = CompanionProfile(
        id: '7',
        userId: 'user7',
        firstName: 'Grace',
        lastName: 'Martinez',
        email: 'grace.martinez@example.com',
        matchIds: ['match6', 'match7'],
        status: true,
      );

      final json = profile.toJson();

      expect(json['id'], equals('7'));
      expect(json['user_id'], equals('user7'));
      expect(json['first_name'], equals('Grace'));
      expect(json['last_name'], equals('Martinez'));
      expect(json['email'], equals('grace.martinez@example.com'));
      expect(json['match_ids'], equals(['match6', 'match7']));
      expect(json['status'], isTrue);
    });

    test('should convert CompanionProfile to JSON with empty matchIds', () {
      final profile = CompanionProfile(
        id: '8',
        userId: 'user8',
        firstName: 'Henry',
        lastName: 'Anderson',
        email: 'henry.anderson@example.com',
        matchIds: [],
        status: false,
      );

      final json = profile.toJson();

      expect(json['id'], equals('8'));
      expect(json['user_id'], equals('user8'));
      expect(json['first_name'], equals('Henry'));
      expect(json['last_name'], equals('Anderson'));
      expect(json['email'], equals('henry.anderson@example.com'));
      expect(json['match_ids'], isEmpty);
      expect(json['status'], isFalse);
    });

    test('should handle special characters in names', () {
      final json = {
        'id': '9',
        'user_id': 'user9',
        'first_name': 'José',
        'last_name': 'O\'Connor',
        'email': 'jose.oconnor@example.com',
        'match_ids': ['match8'],
        'status': true,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.firstName, equals(''));
      expect(profile.lastName, equals(''));
      expect(profile.email, equals('jose.oconnor@example.com'));
    });

    test('should handle long email addresses', () {
      final profile = CompanionProfile(
        id: '10',
        userId: 'user10',
        firstName: 'Ivy',
        lastName: 'Taylor',
        email: 'very.long.email.address.for.testing.purposes@example.com',
        matchIds: ['match9'],
        status: true,
      );

      expect(profile.email, equals('very.long.email.address.for.testing.purposes@example.com'));
    });

    test('should handle multiple match IDs', () {
      final profile = CompanionProfile(
        id: '11',
        userId: 'user11',
        firstName: 'Jack',
        lastName: 'Thomas',
        email: 'jack.thomas@example.com',
        matchIds: ['match1', 'match2', 'match3', 'match4', 'match5'],
        status: true,
      );

      expect(profile.matchIds.length, equals(5));
      expect(profile.matchIds, contains('match1'));
      expect(profile.matchIds, contains('match5'));
    });

    test('should verify JSON structure matches expected format', () {
      final profile = CompanionProfile(
        id: '12',
        userId: 'user12',
        firstName: 'Kate',
        lastName: 'Williams',
        email: 'kate.williams@example.com',
        matchIds: ['match10'],
        status: true,
      );

      final json = profile.toJson();

      expect(json.keys.length, equals(7));
      expect(json.containsKey('id'), isTrue);
      expect(json.containsKey('user_id'), isTrue);
      expect(json.containsKey('first_name'), isTrue);
      expect(json.containsKey('last_name'), isTrue);
      expect(json.containsKey('email'), isTrue);
      expect(json.containsKey('match_ids'), isTrue);
      expect(json.containsKey('status'), isTrue);
    });

    test('should create multiple CompanionProfile instances', () {
      final profile1 = CompanionProfile(
        id: '13',
        userId: 'user13',
        firstName: 'Liam',
        lastName: 'Jones',
        email: 'liam.jones@example.com',
        matchIds: ['match11'],
        status: true,
      );

      final profile2 = CompanionProfile(
        id: '14',
        userId: 'user14',
        firstName: 'Mia',
        lastName: 'Brown',
        email: 'mia.brown@example.com',
        matchIds: ['match12', 'match13'],
        status: false,
      );

      expect(profile1.firstName, equals('Liam'));
      expect(profile2.firstName, equals('Mia'));
      expect(profile1.matchIds.length, equals(1));
      expect(profile2.matchIds.length, equals(2));
      expect(profile1.status, isTrue);
      expect(profile2.status, isFalse);
    });

    test('should handle boolean status values correctly', () {
      final profileTrue = CompanionProfile(
        id: '15',
        userId: 'user15',
        firstName: 'Noah',
        lastName: 'Davis',
        email: 'noah.davis@example.com',
        matchIds: [],
        status: true,
      );

      final profileFalse = CompanionProfile(
        id: '16',
        userId: 'user16',
        firstName: 'Olivia',
        lastName: 'Miller',
        email: 'olivia.miller@example.com',
        matchIds: [],
        status: false,
      );

      expect(profileTrue.status, isTrue);
      expect(profileFalse.status, isFalse);
    });

    test('should handle complex CompanionListResponse with multiple profiles', () {
      final profiles = [
        CompanionProfile(
          id: '17',
          userId: 'user17',
          firstName: 'Peter',
          lastName: 'Wilson',
          email: 'peter.wilson@example.com',
          matchIds: ['match14'],
          status: true,
        ),
        CompanionProfile(
          id: '18',
          userId: 'user18',
          firstName: 'Quinn',
          lastName: 'Moore',
          email: 'quinn.moore@example.com',
          matchIds: ['match15', 'match16'],
          status: false,
        ),
      ];

      final response = CompanionListResponse(
        statusCode: 200,
        messageKey: 'success',
        data: profiles,
      );

      expect(response.statusCode, equals(200));
      expect(response.messageKey, equals('success'));
      expect(response.data!.length, equals(2));
      expect(response.data![0].firstName, equals('Peter'));
      expect(response.data![1].firstName, equals('Quinn'));
    });

    test('should handle UTF-8 encoded strings with hex escape sequences', () {
      final json = {
        'id': '19',
        'user_id': 'user19',
        'first_name': '\\x48\\x65\\x6c\\x6c\\x6f',
        'last_name': '\\x57\\x6f\\x72\\x6c\\x64',
        'email': 'test@example.com',
        'match_ids': ['match17'],
        'status': true,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.id, equals('19'));
      expect(profile.userId, equals('user19'));
      expect(profile.firstName, equals('Hello'));
      expect(profile.lastName, equals('World'));
      expect(profile.email, equals('test@example.com'));
      expect(profile.matchIds, equals(['match17']));
      expect(profile.status, isTrue);
    });

    test('should handle mixed UTF-8 and regular strings', () {
      final json = {
        'id': '20',
        'user_id': 'user20',
        'first_name': '\\x4a\\x6f\\x68\\x6e',
        'last_name': 'Smith',
        'email': 'john.smith@example.com',
        'match_ids': ['match18'],
        'status': false,
      };

      final profile = CompanionProfile.fromJson(json);

      expect(profile.id, equals('20'));
      expect(profile.userId, equals('user20'));
      expect(profile.firstName, equals('John'));
      expect(profile.lastName, equals(''));
      expect(profile.email, equals('john.smith@example.com'));
      expect(profile.matchIds, equals(['match18']));
      expect(profile.status, isFalse);
    });
  });
}
