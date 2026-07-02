import '../client.dart';

/// Response of `POST /v1/api/deletion-request`.
class DeletionRequestResult {
  final String? protocolNumber;
  final String? message;

  const DeletionRequestResult({this.protocolNumber, this.message});

  factory DeletionRequestResult.fromJson(Map<String, dynamic> j) =>
      DeletionRequestResult(
        protocolNumber: j['protocol_number'] as String?,
        message: j['message'] as String?,
      );
}

/// Wraps `POST /v1/api/deletion-request` (scope `lgpd:write`).
///
/// Server-to-server equivalent of the personal portal's
/// `POST /v1/me/deletion-request`, but takes an explicit `person_id`.
class LgpdModule {
  final VelixClient _client;
  LgpdModule(this._client);

  Future<DeletionRequestResult> requestDeletion(String personId) async {
    final data = await _client
        .post('/v1/api/deletion-request', {'person_id': personId});
    return DeletionRequestResult.fromJson(data as Map<String, dynamic>);
  }
}
