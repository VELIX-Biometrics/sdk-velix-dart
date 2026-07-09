import '../client.dart';

/// `/v1/contexts/*` — Identity Context (Velix.ID). BearerAuth (session JWT).
/// See code/lib/lib-velix-contracts/openapi/public-api.yaml, tag "Identity Context".
class ContextModule {
  final VelixClient _client;
  ContextModule(this._client);

  Future<dynamic> create(Map<String, dynamic> payload) =>
      _client.post('/v1/contexts', payload);

  Future<dynamic> get(String id) => _client.get('/v1/contexts/$id');

  Future<dynamic> list() => _client.get('/v1/contexts');

  Future<dynamic> update(String id, Map<String, dynamic> payload) =>
      _client.patch('/v1/contexts/$id', payload);

  Future<void> remove(String id) => _client.delete('/v1/contexts/$id');

  /// `POST /v1/contexts/{contextId}/authorize` — Authorization Engine.
  Future<dynamic> authorize(String contextId, Map<String, dynamic> payload) =>
      _client.post('/v1/contexts/$contextId/authorize', payload);

  Future<dynamic> listAuthorizationDecisions(String contextId) =>
      _client.get('/v1/contexts/$contextId/authorization-decisions');

  /// `POST /v1/contexts/{contextId}/link-requests` — solicita vínculo
  /// cross-tenant. Nunca cria membership diretamente: retorna 202 (PENDING)
  /// aguardando consentimento via magic link/notificação. A API pública não
  /// expõe approve/reject — isso acontece fora do SDK.
  Future<dynamic> createLinkRequest(
          String contextId, Map<String, dynamic> payload) =>
      _client.post('/v1/contexts/$contextId/link-requests', payload);
}

class ContextMembershipModule {
  final VelixClient _client;
  ContextMembershipModule(this._client);

  Future<dynamic> create(String contextId, Map<String, dynamic> payload) =>
      _client.post('/v1/contexts/$contextId/memberships', payload);

  Future<dynamic> listByContext(String contextId) =>
      _client.get('/v1/contexts/$contextId/memberships');

  Future<dynamic> listByIdentity(String identityId) =>
      _client.get('/v1/identities/$identityId/memberships');

  /// `status = 'revoked'` é a saída de contexto (definitiva, sem carência, task #834).
  Future<dynamic> updateStatus(String membershipId, String status) =>
      _client.patch('/v1/memberships/$membershipId/status', {'status': status});

  Future<dynamic> addRoles(String membershipId, List<String> roleIds) =>
      _client.post('/v1/memberships/$membershipId/roles', {'roleIds': roleIds});

  Future<dynamic> removeRoles(String membershipId, List<String> roleIds) =>
      _client.post(
          '/v1/memberships/$membershipId/roles/remove', {'roleIds': roleIds});
}

class ContextRoleModule {
  final VelixClient _client;
  ContextRoleModule(this._client);

  Future<dynamic> create(Map<String, dynamic> payload) =>
      _client.post('/v1/context-roles', payload);

  Future<dynamic> list(String contextType) =>
      _client.get('/v1/context-roles?contextType=$contextType');

  Future<dynamic> linkPermissions(String roleId, List<String> permissionIds) =>
      _client.post('/v1/context-roles/$roleId/permissions',
          {'permissionIds': permissionIds});
}

class ContextPermissionModule {
  final VelixClient _client;
  ContextPermissionModule(this._client);

  Future<dynamic> create(Map<String, dynamic> payload) =>
      _client.post('/v1/context-permissions', payload);

  Future<dynamic> list({String? category}) => _client.get(
      category != null
          ? '/v1/context-permissions?category=$category'
          : '/v1/context-permissions');
}

class AuthorizationTokenModule {
  final VelixClient _client;
  AuthorizationTokenModule(this._client);

  /// `POST /v1/authorization-tokens/validate` — valida (e opcionalmente
  /// consome) um token vat_*.
  Future<dynamic> validate(String token, {bool consume = false}) =>
      _client.post('/v1/authorization-tokens/validate',
          {'token': token, 'consume': consume});
}
