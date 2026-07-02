import '../client.dart';

class Person {
  final String id;
  final String name;
  final String? email;
  final String? document;
  final bool biometricEnrolled;
  final String? status;

  const Person({
    required this.id,
    required this.name,
    this.email,
    this.document,
    this.biometricEnrolled = false,
    this.status,
  });

  factory Person.fromJson(Map<String, dynamic> j) => Person(
        id: j['id'] as String,
        name: j['name'] as String,
        email: j['email'] as String?,
        document: j['document'] as String?,
        biometricEnrolled: j['biometric_enrolled'] as bool? ?? false,
        status: j['status'] as String?,
      );

  Person copyWith({
    String? id,
    String? name,
    String? email,
    String? document,
    bool? biometricEnrolled,
    String? status,
  }) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        document: document ?? this.document,
        biometricEnrolled: biometricEnrolled ?? this.biometricEnrolled,
        status: status ?? this.status,
      );
}

class PersonsModule {
  final VelixClient _client;
  PersonsModule(this._client);

  Future<List<Person>> list({int page = 1, int limit = 20}) async {
    final data = await _client.get('/v1/persons?page=$page&limit=$limit');
    final items = (data as Map<String, dynamic>)['items'] as List;
    return items.map((e) => Person.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Person> get(String id) async {
    final data = await _client.get('/v1/persons/$id');
    return Person.fromJson(data as Map<String, dynamic>);
  }

  Future<Person> create(Map<String, dynamic> body) async {
    final data = await _client.post('/v1/persons', body);
    return Person.fromJson(data as Map<String, dynamic>);
  }

  Future<Person> update(String id, Map<String, dynamic> body) async {
    final data = await _client.put('/v1/persons/$id', body);
    return Person.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String id) => _client.delete('/v1/persons/$id');

  Future<void> enroll(String id, List<String> frames) async {
    await _client.post('/v1/persons/$id/enroll', {'frames': frames});
  }
}
