import '../client.dart';

/// One liveness sample submitted alongside a checkin identify request.
/// Wire fields: `action`, `imageBase64` (camelCase per spec, not snake_case).
class LivenessSample {
  final String action; // center | move_closer | move_away
  final String imageBase64;

  const LivenessSample({required this.action, required this.imageBase64});

  Map<String, dynamic> toJson() => {
        'action': action,
        'imageBase64': imageBase64,
      };
}

/// Liveness block: nonce obtained from the public HMAC challenge endpoint
/// (`GET /v1/public/checkin/{tenantSlug}/liveness/challenge`) plus samples.
class LivenessBlock {
  final String token;
  final List<LivenessSample> samples;

  const LivenessBlock({required this.token, required this.samples});

  Map<String, dynamic> toJson() => {
        'token': token,
        'samples': samples.map((s) => s.toJson()).toList(),
      };
}

/// Optional geolocation attached to a checkin identify request.
class CheckinLocation {
  final double latitude;
  final double longitude;
  final double? accuracy;

  const CheckinLocation({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
      };
}

/// Result of `POST /v1/api/checkin/identify`.
///
/// The liveness score is NEVER exposed by the API (security rule, see
/// CLAUDE.md gotcha #5) — only `matched`/`quality_score`/`message` are
/// available here.
class CheckinResult {
  final bool matched;
  final String? personId;
  final double? qualityScore;
  final String? message;

  const CheckinResult({
    required this.matched,
    this.personId,
    this.qualityScore,
    this.message,
  });

  factory CheckinResult.fromJson(Map<String, dynamic> j) => CheckinResult(
        matched: j['matched'] as bool? ?? false,
        personId: j['person_id'] as String?,
        qualityScore: (j['quality_score'] as num?)?.toDouble(),
        message: j['message'] as String?,
      );

  CheckinResult copyWith({
    bool? matched,
    String? personId,
    double? qualityScore,
    String? message,
  }) =>
      CheckinResult(
        matched: matched ?? this.matched,
        personId: personId ?? this.personId,
        qualityScore: qualityScore ?? this.qualityScore,
        message: message ?? this.message,
      );
}

/// Wraps `POST /v1/api/checkin/identify` (scope `checkin:write`).
///
/// This is the ONLY real checkin endpoint under the API-key surface. It
/// calls the same `CheckinService.identifyFace()` used by the public HMAC
/// flow (`/v1/public/checkin/{tenantSlug}/identify`), which is NOT part of
/// this SDK's scope.
class CheckinModule {
  final VelixClient _client;
  CheckinModule(this._client);

  Future<CheckinResult> identify({
    required String imageBase64,
    List<String>? images,
    int? topK,
    LivenessBlock? liveness,
    CheckinLocation? location,
  }) async {
    final body = <String, dynamic>{
      'imageBase64': imageBase64,
      if (images != null) 'images': images,
      if (topK != null) 'topK': topK,
      if (liveness != null) 'liveness': liveness.toJson(),
      if (location != null) 'location': location.toJson(),
    };
    final data = await _client.post('/v1/api/checkin/identify', body);
    return CheckinResult.fromJson(data as Map<String, dynamic>);
  }

  // NOTE: qr() and pin() checkin modes do NOT exist in the API-key surface
  // documented at lib-velix-contracts/openapi/public-api.yaml (only facial
  // identify via /v1/api/checkin/identify is exposed). Previous versions of
  // this SDK exposed qr()/pin() pointing at a non-existent
  // /v1/checkin/{tenantSlug}/identify endpoint — removed as part of task
  // #593/#656 contract realignment.
}
