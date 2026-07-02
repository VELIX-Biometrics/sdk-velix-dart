import '../client.dart';

/// Event guest — returned by both guest creation and guest lookup.
/// Wire fields use camelCase (`eventId`, `categoryId`), unlike the
/// snake_case DTOs of onboarding/checkin/me/lgpd.
class Guest {
  final String? id;
  final String? eventId;
  final String name;
  final String email;
  final String? status;
  final String? categoryId;

  const Guest({
    this.id,
    this.eventId,
    required this.name,
    required this.email,
    this.status,
    this.categoryId,
  });

  factory Guest.fromJson(Map<String, dynamic> j) => Guest(
        id: j['id'] as String?,
        eventId: j['eventId'] as String?,
        name: j['name'] as String,
        email: j['email'] as String,
        status: j['status'] as String?,
        categoryId: j['categoryId'] as String?,
      );

  Guest copyWith({
    String? id,
    String? eventId,
    String? name,
    String? email,
    String? status,
    String? categoryId,
  }) =>
      Guest(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        name: name ?? this.name,
        email: email ?? this.email,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
      );
}

/// Wraps the two Velix Events endpoints exposed under the API-key surface:
/// `POST /v1/api/events/{id}/guests` (scope `events:write`) and
/// `GET /v1/api/events/{id}/guests/{guestId}` (scope `events:read`).
///
/// No listing/creation/config endpoints for events themselves exist in the
/// API-key surface (only guest create/read) — previous versions of this
/// module exposed list()/get()/create()/updateConfig()/delete() against
/// invented `/v1/events*` endpoints that do not exist; removed as part of
/// task #593/#656 contract realignment.
class EventsModule {
  final VelixClient _client;
  EventsModule(this._client);

  Future<Guest> createGuest(
    String eventId, {
    required String name,
    required String email,
    String? cpf,
    String? phone,
    String? birthDate,
    String? categoryId,
    String? companionOf,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      if (cpf != null) 'cpf': cpf,
      if (phone != null) 'phone': phone,
      if (birthDate != null) 'birthDate': birthDate,
      if (categoryId != null) 'categoryId': categoryId,
      if (companionOf != null) 'companionOf': companionOf,
    };
    final data =
        await _client.post('/v1/api/events/$eventId/guests', body);
    return Guest.fromJson(data as Map<String, dynamic>);
  }

  Future<Guest> getGuest(String eventId, String guestId) async {
    final data =
        await _client.get('/v1/api/events/$eventId/guests/$guestId');
    return Guest.fromJson(data as Map<String, dynamic>);
  }
}
