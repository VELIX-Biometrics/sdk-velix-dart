import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('LgpdModule models', () {
    test('DeletionRequestResult.fromJson parses protocol_number', () {
      final result = DeletionRequestResult.fromJson({
        'protocol_number': 'DEL-2026-001',
        'message': 'Deletion request registered',
      });
      expect(result.protocolNumber, equals('DEL-2026-001'));
      expect(result.message, equals('Deletion request registered'));
    });

    test('DeletionRequestResult.fromJson handles missing fields', () {
      final result = DeletionRequestResult.fromJson({});
      expect(result.protocolNumber, isNull);
      expect(result.message, isNull);
    });
  });
}
