import '../client.dart';

class VelixEvent {
  final String id;
  final String name;
  final String? description;
  final String status;
  final String? startAt;
  final String? endAt;

  const VelixEvent({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.startAt,
    this.endAt,
  });

  factory VelixEvent.fromJson(Map<String, dynamic> j) => VelixEvent(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String?,
        status: j['status'] as String? ?? 'draft',
        startAt: j['start_at'] as String?,
        endAt: j['end_at'] as String?,
      );

  VelixEvent copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    String? startAt,
    String? endAt,
  }) =>
      VelixEvent(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        status: status ?? this.status,
        startAt: startAt ?? this.startAt,
        endAt: endAt ?? this.endAt,
      );
}

class EventsModule {
  final VelixClient _client;
  EventsModule(this._client);

  Future<List<VelixEvent>> list({int page = 1, int limit = 20}) async {
    final data = await _client.get('/v1/events?page=$page&limit=$limit');
    final items = (data as Map<String, dynamic>)['items'] as List;
    return items
        .map((e) => VelixEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VelixEvent> get(String id) async {
    final data = await _client.get('/v1/events/$id');
    return VelixEvent.fromJson(data as Map<String, dynamic>);
  }

  Future<VelixEvent> create(Map<String, dynamic> body) async {
    final data = await _client.post('/v1/events', body);
    return VelixEvent.fromJson(data as Map<String, dynamic>);
  }

  Future<VelixEvent> updateConfig(
      String id, Map<String, dynamic> config) async {
    final data = await _client.patch('/v1/events/$id/config', config);
    return VelixEvent.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String id) => _client.delete('/v1/events/$id');
}
