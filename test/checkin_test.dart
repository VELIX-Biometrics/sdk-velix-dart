import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('CheckinModule models', () {
    test('CheckinResult.fromJson parses matched checkin', () {
      final result = CheckinResult.fromJson({
        'matched': true,
        'person_id': 'uuid-123',
        'quality_score': 0.91,
        'message': 'OK',
      });
      expect(result.matched, isTrue);
      expect(result.personId, equals('uuid-123'));
      expect(result.qualityScore, equals(0.91));
    });

    test('CheckinResult.fromJson never exposes a liveness score field', () {
      final result = CheckinResult.fromJson({'matched': false});
      // Only matched/person_id/quality_score/message exist on the model —
      // there is no livenessScore getter by design (security rule).
      expect(result.matched, isFalse);
      expect(result.personId, isNull);
    });

    test('CheckinResult.copyWith preserves unset fields', () {
      const original = CheckinResult(matched: true, personId: 'abc');
      final updated = original.copyWith(matched: false);
      expect(updated.matched, isFalse);
      expect(updated.personId, equals('abc'));
    });

    test('LivenessSample.toJson uses camelCase imageBase64', () {
      const sample = LivenessSample(action: 'center', imageBase64: 'abc123');
      final json = sample.toJson();
      expect(json['action'], equals('center'));
      expect(json['imageBase64'], equals('abc123'));
    });

    test('LivenessBlock.toJson serializes token and samples', () {
      const block = LivenessBlock(
        token: 'nonce-token',
        samples: [LivenessSample(action: 'center', imageBase64: 'abc')],
      );
      final json = block.toJson();
      expect(json['token'], equals('nonce-token'));
      expect(json['samples'], hasLength(1));
    });
  });
}
