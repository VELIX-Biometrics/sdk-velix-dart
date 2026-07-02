import '../client.dart';

/// Result of processing a single enrollment frame.
/// Wire field: `frame_index`, `quality_passed`, `quality_score`, `liveness_passed`.
class FrameResult {
  final int frameIndex;
  final bool qualityPassed;
  final double? qualityScore;
  final bool? livenessPassed;

  const FrameResult({
    required this.frameIndex,
    required this.qualityPassed,
    this.qualityScore,
    this.livenessPassed,
  });

  factory FrameResult.fromJson(Map<String, dynamic> j) => FrameResult(
        frameIndex: j['frame_index'] as int,
        qualityPassed: j['quality_passed'] as bool,
        qualityScore: (j['quality_score'] as num?)?.toDouble(),
        livenessPassed: j['liveness_passed'] as bool?,
      );
}

/// Response of `POST /v1/api/onboarding`.
class OnboardingResult {
  final String? personId;
  final String? identityId;
  final bool enrolled;
  final int? framesProcessed;
  final List<FrameResult> framesResults;
  final String? embeddingId;
  final String? message;

  const OnboardingResult({
    this.personId,
    this.identityId,
    required this.enrolled,
    this.framesProcessed,
    this.framesResults = const [],
    this.embeddingId,
    this.message,
  });

  factory OnboardingResult.fromJson(Map<String, dynamic> j) =>
      OnboardingResult(
        personId: j['person_id'] as String?,
        identityId: j['identity_id'] as String?,
        enrolled: j['enrolled'] as bool? ?? false,
        framesProcessed: j['frames_processed'] as int?,
        framesResults: (j['frames_results'] as List<dynamic>?)
                ?.map((e) => FrameResult.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        embeddingId: j['embedding_id'] as String?,
        message: j['message'] as String?,
      );
}

/// Wraps `POST /v1/api/onboarding` (scope `onboarding:write`).
///
/// See OnboardingRequest/OnboardingResponse in
/// lib-velix-contracts/openapi/public-api.yaml.
class OnboardingModule {
  final VelixClient _client;
  OnboardingModule(this._client);

  Future<OnboardingResult> enroll({
    required String name,
    required List<String> frames,
    String? email,
    String? phone,
    String? document,
    String? documentType,
    String? externalId,
    Map<String, dynamic>? metadata,
    String? role,
    List<String>? accessGroups,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'frames': frames,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (document != null) 'document': document,
      if (documentType != null) 'document_type': documentType,
      if (externalId != null) 'external_id': externalId,
      if (metadata != null) 'metadata': metadata,
      if (role != null) 'role': role,
      if (accessGroups != null) 'access_groups': accessGroups,
    };
    final data = await _client.post('/v1/api/onboarding', body);
    return OnboardingResult.fromJson(data as Map<String, dynamic>);
  }
}
