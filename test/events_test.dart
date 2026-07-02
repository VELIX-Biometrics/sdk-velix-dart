import 'dart:convert';
import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('EventsModule', () {
    test('EventsListResult.fromJson parses correctly', () {
      final json = {
        'items': [
          {'id': 'evt-1', 'name': 'Tech Summit', 'status': 'active'}
        ],
        'total': 1,
        'page': 1,
        'limit': 20,
      };
      final result = EventsListResult.fromJson(json);
      expect(result.total, equals(1));
      expect(result.items.length, equals(1));
      expect(result.items.first.id, equals('evt-1'));
    });

    test('VelixEvent.fromJson parses correctly', () {
      final json = {'id': 'evt-1', 'name': 'Tech Summit', 'status': 'active'};
      final event = VelixEvent.fromJson(json);
      expect(event.id, equals('evt-1'));
      expect(event.name, equals('Tech Summit'));
      expect(event.status, equals('active'));
    });

    test('VelixEvent.copyWith preserves unset fields', () {
      const original = VelixEvent(id: 'evt-1', name: 'Summit', status: 'active');
      final updated = original.copyWith(status: 'closed');
      expect(updated.status, equals('closed'));
      expect(updated.id, equals('evt-1'));
      expect(updated.name, equals('Summit'));
    });

    test('VelixEvent.fromJson handles null optional fields', () {
      final json = {'id': 'evt-1', 'name': 'Summit', 'status': 'draft'};
      final event = VelixEvent.fromJson(json);
      expect(event.id, equals('evt-1'));
    });
  });
}
