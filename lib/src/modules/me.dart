import '../client.dart';

/// Response of `GET /v1/api/me/{personId}`.
class MeInfo {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String? createdAt;

  const MeInfo({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.createdAt,
  });

  factory MeInfo.fromJson(Map<String, dynamic> j) => MeInfo(
        id: j['id'] as String?,
        name: j['name'] as String?,
        email: j['email'] as String?,
        phone: j['phone'] as String?,
        photoUrl: j['photo_url'] as String?,
        createdAt: j['created_at'] as String?,
      );
}

/// Wraps `GET /v1/api/me/{personId}` (scope `me:read`).
///
/// Server-to-server equivalent of the personal portal's `GET /v1/me`, by
/// explicit personId. The identity-core validates the person belongs to the
/// API key's tenant before returning data (403 otherwise).
class MeModule {
  final VelixClient _client;
  MeModule(this._client);

  Future<MeInfo> get(String personId) async {
    final data = await _client.get('/v1/api/me/$personId');
    return MeInfo.fromJson(data as Map<String, dynamic>);
  }
}
