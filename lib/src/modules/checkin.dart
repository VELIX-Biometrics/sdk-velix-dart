import '../client.dart';

class CheckinResult {
  final bool passed;
  final String? personId;
  final String? personName;
  final String? reason;

  const CheckinResult({
    required this.passed,
    this.personId,
    this.personName,
    this.reason,
  });

  factory CheckinResult.fromJson(Map<String, dynamic> j) => CheckinResult(
        passed: j['passed'] as bool,
        personId: j['person_id'] as String?,
        personName: j['person_name'] as String?,
        reason: j['reason'] as String?,
      );

  CheckinResult copyWith({
    bool? passed,
    String? personId,
    String? personName,
    String? reason,
  }) =>
      CheckinResult(
        passed: passed ?? this.passed,
        personId: personId ?? this.personId,
        personName: personName ?? this.personName,
        reason: reason ?? this.reason,
      );
}

class CheckinModule {
  final VelixClient _client;
  CheckinModule(this._client);

  Future<CheckinResult> facial(String tenantSlug, String frameBase64) async {
    final data = await _client.post(
      '/v1/checkin/$tenantSlug/identify',
      {'frame': frameBase64, 'mode': 'facial'},
    );
    return CheckinResult.fromJson(data as Map<String, dynamic>);
  }

  Future<CheckinResult> qr(String tenantSlug, String qrCode) async {
    final data = await _client.post(
      '/v1/checkin/$tenantSlug/identify',
      {'qr_code': qrCode, 'mode': 'qr'},
    );
    return CheckinResult.fromJson(data as Map<String, dynamic>);
  }

  Future<CheckinResult> pin(String tenantSlug, String pin) async {
    final data = await _client.post(
      '/v1/checkin/$tenantSlug/identify',
      {'pin': pin, 'mode': 'pin'},
    );
    return CheckinResult.fromJson(data as Map<String, dynamic>);
  }
}
