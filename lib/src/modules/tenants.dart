import '../client.dart';

class Tenant {
  final String id;
  final String name;
  final String slug;
  final String plan;
  final Map<String, dynamic> settings;

  const Tenant({
    required this.id,
    required this.name,
    required this.slug,
    required this.plan,
    this.settings = const {},
  });

  factory Tenant.fromJson(Map<String, dynamic> j) => Tenant(
        id: j['id'] as String,
        name: j['name'] as String,
        slug: j['slug'] as String,
        plan: j['plan'] as String? ?? 'starter',
        settings: j['settings'] as Map<String, dynamic>? ?? {},
      );

  Tenant copyWith({
    String? id,
    String? name,
    String? slug,
    String? plan,
    Map<String, dynamic>? settings,
  }) =>
      Tenant(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        plan: plan ?? this.plan,
        settings: settings ?? this.settings,
      );
}

class TenantsModule {
  final VelixClient _client;
  TenantsModule(this._client);

  Future<Tenant> me() async {
    final data = await _client.get('/v1/tenants/me');
    return Tenant.fromJson(data as Map<String, dynamic>);
  }

  Future<Tenant> updateSettings(Map<String, dynamic> settings) async {
    final data = await _client.put('/v1/tenants/me/settings', settings);
    return Tenant.fromJson(data as Map<String, dynamic>);
  }
}
