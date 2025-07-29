import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/companion/model/add_companion_model.dart';

void main() {
  group('AddCompanion', () {
    test('should create AddCompanion instance with required parameters', () {
      final companion = AddCompanion(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        matchIds: ['match1', 'match2'],
      );

      expect(companion.firstName, equals('John'));
      expect(companion.lastName, equals('Doe'));
      expect(companion.email, equals('john.doe@example.com'));
      expect(companion.matchIds, equals(['match1', 'match2']));
    });

    test('should create AddCompanion instance with empty matchIds', () {
      final companion = AddCompanion(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@example.com',
        matchIds: [],
      );

      expect(companion.firstName, equals('Jane'));
      expect(companion.lastName, equals('Smith'));
      expect(companion.email, equals('jane.smith@example.com'));
      expect(companion.matchIds, isEmpty);
    });

    test('should create AddCompanion from JSON', () {
      final json = {
        'first_name': 'Alice',
        'last_name': 'Johnson',
        'email': 'alice.johnson@example.com',
        'match_ids': ['match3', 'match4', 'match5'],
      };

      final companion = AddCompanion.fromJson(json);

      expect(companion.firstName, equals('Alice'));
      expect(companion.lastName, equals('Johnson'));
      expect(companion.email, equals('alice.johnson@example.com'));
      expect(companion.matchIds, equals(['match3', 'match4', 'match5']));
    });

    test('should create AddCompanion from JSON with null match_ids', () {
      final json = {
        'first_name': 'Bob',
        'last_name': 'Wilson',
        'email': 'bob.wilson@example.com',
        'match_ids': null,
      };

      final companion = AddCompanion.fromJson(json);

      expect(companion.firstName, equals('Bob'));
      expect(companion.lastName, equals('Wilson'));
      expect(companion.email, equals('bob.wilson@example.com'));
      expect(companion.matchIds, isEmpty);
    });

    test('should create AddCompanion from JSON with missing match_ids', () {
      final json = {
        'first_name': 'Charlie',
        'last_name': 'Brown',
        'email': 'charlie.brown@example.com',
      };

      final companion = AddCompanion.fromJson(json);

      expect(companion.firstName, equals('Charlie'));
      expect(companion.lastName, equals('Brown'));
      expect(companion.email, equals('charlie.brown@example.com'));
      expect(companion.matchIds, isEmpty);
    });

    test('should convert AddCompanion to JSON', () {
      final companion = AddCompanion(
        firstName: 'David',
        lastName: 'Miller',
        email: 'david.miller@example.com',
        matchIds: ['match6', 'match7'],
      );

      final json = companion.toJson();

      expect(json['first_name'], equals('David'));
      expect(json['last_name'], equals('Miller'));
      expect(json['email'], equals('david.miller@example.com'));
      expect(json['match_ids'], equals(['match6', 'match7']));
    });

    test('should convert AddCompanion to JSON with empty matchIds', () {
      final companion = AddCompanion(
        firstName: 'Eva',
        lastName: 'Davis',
        email: 'eva.davis@example.com',
        matchIds: [],
      );

      final json = companion.toJson();

      expect(json['first_name'], equals('Eva'));
      expect(json['last_name'], equals('Davis'));
      expect(json['email'], equals('eva.davis@example.com'));
      expect(json['match_ids'], isEmpty);
    });

    test('should convert AddCompanion to JSON for edit with non-empty matchIds', () {
      final companion = AddCompanion(
        firstName: 'Frank',
        lastName: 'Garcia',
        email: 'frank.garcia@example.com',
        matchIds: ['match8', 'match9'],
      );

      final json = companion.toJsonEdit();

      expect(json['first_name'], equals('Frank'));
      expect(json['last_name'], equals('Garcia'));
      expect(json['match_ids'], equals(['match8', 'match9']));
    });

    test('should convert AddCompanion to JSON for edit with empty matchIds', () {
      final companion = AddCompanion(
        firstName: 'Grace',
        lastName: 'Martinez',
        email: 'grace.martinez@example.com',
        matchIds: [],
      );

      final json = companion.toJsonEdit();

      expect(json['first_name'], equals('Grace'));
      expect(json['last_name'], equals('Martinez'));
      expect(json.containsKey('match_ids'), isFalse);
    });

    test('should handle null values in toJsonEdit method', () {
      final companion = AddCompanion(
        firstName: 'Henry',
        lastName: 'Anderson',
        email: 'henry.anderson@example.com',
        matchIds: [],
      );

      final json = companion.toJsonEdit();

      expect(json['first_name'], equals('Henry'));
      expect(json['last_name'], equals('Anderson'));
    });

    test('should create multiple AddCompanion instances', () {
      final companion1 = AddCompanion(
        firstName: 'Ivy',
        lastName: 'Taylor',
        email: 'ivy.taylor@example.com',
        matchIds: ['match10'],
      );

      final companion2 = AddCompanion(
        firstName: 'Jack',
        lastName: 'Thomas',
        email: 'jack.thomas@example.com',
        matchIds: ['match11', 'match12'],
      );

      expect(companion1.firstName, equals('Ivy'));
      expect(companion2.firstName, equals('Jack'));
      expect(companion1.matchIds.length, equals(1));
      expect(companion2.matchIds.length, equals(2));
    });

    test('should handle special characters in names', () {
      final companion = AddCompanion(
        firstName: 'José',
        lastName: 'O\'Connor',
        email: 'jose.oconnor@example.com',
        matchIds: ['match13'],
      );

      expect(companion.firstName, equals('José'));
      expect(companion.lastName, equals('O\'Connor'));
      expect(companion.email, equals('jose.oconnor@example.com'));
    });

    test('should handle long email addresses', () {
      final companion = AddCompanion(
        firstName: 'Kate',
        lastName: 'Williams',
        email: 'very.long.email.address.for.testing.purposes@example.com',
        matchIds: ['match14'],
      );

      expect(companion.email, equals('very.long.email.address.for.testing.purposes@example.com'));
    });

    test('should handle multiple match IDs', () {
      final companion = AddCompanion(
        firstName: 'Liam',
        lastName: 'Jones',
        email: 'liam.jones@example.com',
        matchIds: ['match1', 'match2', 'match3', 'match4', 'match5'],
      );

      expect(companion.matchIds.length, equals(5));
      expect(companion.matchIds, contains('match1'));
      expect(companion.matchIds, contains('match5'));
    });

    test('should create AddCompanion from JSON with empty match_ids array', () {
      final json = {
        'first_name': 'Mia',
        'last_name': 'Brown',
        'email': 'mia.brown@example.com',
        'match_ids': [],
      };

      final companion = AddCompanion.fromJson(json);

      expect(companion.firstName, equals('Mia'));
      expect(companion.lastName, equals('Brown'));
      expect(companion.email, equals('mia.brown@example.com'));
      expect(companion.matchIds, isEmpty);
    });

    test('should verify JSON structure matches expected format', () {
      final companion = AddCompanion(
        firstName: 'Noah',
        lastName: 'Davis',
        email: 'noah.davis@example.com',
        matchIds: ['match15'],
      );

      final json = companion.toJson();

      expect(json.keys.length, equals(4));
      expect(json.containsKey('first_name'), isTrue);
      expect(json.containsKey('last_name'), isTrue);
      expect(json.containsKey('email'), isTrue);
      expect(json.containsKey('match_ids'), isTrue);
    });

    test('should verify JSON edit structure for non-empty matchIds', () {
      final companion = AddCompanion(
        firstName: 'Olivia',
        lastName: 'Miller',
        email: 'olivia.miller@example.com',
        matchIds: ['match16'],
      );

      final json = companion.toJsonEdit();

      expect(json.keys.length, equals(3));
      expect(json.containsKey('first_name'), isTrue);
      expect(json.containsKey('last_name'), isTrue);
      expect(json.containsKey('match_ids'), isTrue);
      expect(json.containsKey('email'), isFalse);
    });

    test('should verify JSON edit structure for empty matchIds', () {
      final companion = AddCompanion(
        firstName: 'Peter',
        lastName: 'Wilson',
        email: 'peter.wilson@example.com',
        matchIds: [],
      );

      final json = companion.toJsonEdit();

      expect(json.keys.length, equals(2));
      expect(json.containsKey('first_name'), isTrue);
      expect(json.containsKey('last_name'), isTrue);
      expect(json.containsKey('match_ids'), isFalse);
      expect(json.containsKey('email'), isFalse);
    });
  });
}
