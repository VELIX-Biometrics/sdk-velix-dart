import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('OnboardingModule models', () {
    test('OnboardingResult.fromJson parses snake_case wire fields', () {
      final json = {
        'person_id': 'p-1',
        'identity_id': 'i-1',
        'enrolled': true,
        'frames_processed': 3,
        'frames_results': [
          {
            'frame_index': 0,
            'quality_passed': true,
            'quality_score': 0.87,
            'liveness_passed': true,
          }
        ],
        'embedding_id': 'e-1',
        'message': 'Enrolled successfully',
      };
      final result = OnboardingResult.fromJson(json);
      expect(result.personId, equals('p-1'));
      expect(result.identityId, equals('i-1'));
      expect(result.enrolled, isTrue);
      expect(result.framesProcessed, equals(3));
      expect(result.framesResults, hasLength(1));
      expect(result.framesResults.first.frameIndex, equals(0));
      expect(result.framesResults.first.qualityPassed, isTrue);
    });

    test('OnboardingResult.fromJson defaults enrolled to false and frames to empty', () {
      final result = OnboardingResult.fromJson({});
      expect(result.enrolled, isFalse);
      expect(result.framesResults, isEmpty);
    });
  });
}
