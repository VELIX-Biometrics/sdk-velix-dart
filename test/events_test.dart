import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('EventsModule models', () {
    test('Guest.fromJson parses camelCase wire fields', () {
      final json = {
        'id': 'guest-1',
        'eventId': 'evt-1',
        'name': 'João Silva',
        'email': 'joao@empresa.com',
        'status': 'confirmed',
        'categoryId': 'cat-1',
      };
      final guest = Guest.fromJson(json);
      expect(guest.id, equals('guest-1'));
      expect(guest.eventId, equals('evt-1'));
      expect(guest.name, equals('João Silva'));
      expect(guest.status, equals('confirmed'));
      expect(guest.categoryId, equals('cat-1'));
    });

    test('Guest.fromJson handles null optional fields', () {
      final json = {'name': 'Maria', 'email': 'maria@empresa.com'};
      final guest = Guest.fromJson(json);
      expect(guest.name, equals('Maria'));
      expect(guest.id, isNull);
      expect(guest.categoryId, isNull);
    });

    test('Guest.copyWith preserves unset fields', () {
      const original = Guest(id: 'g1', name: 'Ana', email: 'ana@empresa.com');
      final updated = original.copyWith(status: 'checked_in');
      expect(updated.status, equals('checked_in'));
      expect(updated.id, equals('g1'));
      expect(updated.name, equals('Ana'));
    });
  });
}
