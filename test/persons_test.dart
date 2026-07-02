import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('Person model', () {
    test('fromJson parses correctly', () {
      final person = Person.fromJson({
        'id': 'uuid-456',
        'name': 'Maria Silva',
        'email': 'maria@empresa.com',
        'biometric_enrolled': true,
        'status': 'active',
      });
      expect(person.id, equals('uuid-456'));
      expect(person.name, equals('Maria Silva'));
      expect(person.biometricEnrolled, isTrue);
    });

    test('copyWith updates only specified fields', () {
      const original = Person(id: '1', name: 'João', biometricEnrolled: false);
      final updated = original.copyWith(biometricEnrolled: true);
      expect(updated.biometricEnrolled, isTrue);
      expect(updated.name, equals('João'));
    });

    test('biometricEnrolled defaults to false', () {
      final person = Person.fromJson({'id': '1', 'name': 'Test'});
      expect(person.biometricEnrolled, isFalse);
    });
  });
}
