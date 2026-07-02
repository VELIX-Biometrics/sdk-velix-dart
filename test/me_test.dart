import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('MeModule models', () {
    test('MeInfo.fromJson parses snake_case wire fields', () {
      final json = {
        'id': 'p-1',
        'name': 'Maria Silva',
        'email': 'maria@empresa.com',
        'phone': '+5511999999999',
        'photo_url': 'https://cdn.velixbiometrics.com/p-1.jpg',
        'created_at': '2026-01-01T00:00:00Z',
      };
      final me = MeInfo.fromJson(json);
      expect(me.id, equals('p-1'));
      expect(me.name, equals('Maria Silva'));
      expect(me.photoUrl, equals('https://cdn.velixbiometrics.com/p-1.jpg'));
      expect(me.createdAt, equals('2026-01-01T00:00:00Z'));
    });

    test('MeInfo.fromJson handles null optional fields', () {
      final me = MeInfo.fromJson({'id': 'p-1', 'name': 'Test'});
      expect(me.email, isNull);
      expect(me.photoUrl, isNull);
    });
  });
}
