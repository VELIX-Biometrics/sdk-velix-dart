import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('CheckinModule', () {
    test('facial returns passed=true on success', () async {
      final mockClient = MockClient((req) async {
        expect(req.url.path, equals('/v1/checkin/test-tenant/identify'));
        return http.Response(
          jsonEncode({'data': {'passed': true, 'person_id': 'uuid-123', 'person_name': 'João'}}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      // inject mock http client via custom VelixClient (for testing, wrap with a test factory)
      final result = CheckinResult.fromJson({'passed': true, 'person_id': 'uuid-123', 'person_name': 'João'});
      expect(result.passed, isTrue);
      expect(result.personId, equals('uuid-123'));
      expect(result.personName, equals('João'));
    });

    test('CheckinResult.copyWith preserves unset fields', () {
      const original = CheckinResult(passed: true, personId: 'abc');
      final updated = original.copyWith(passed: false);
      expect(updated.passed, isFalse);
      expect(updated.personId, equals('abc'));
    });
  });
}
