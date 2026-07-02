import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'error.dart';
import 'retry.dart';
import 'modules/checkin.dart';
import 'modules/persons.dart';
import 'modules/events.dart';
import 'modules/tenants.dart';

class VelixClient {
  final VelixConfig config;
  late final CheckinModule checkin;
  late final PersonsModule persons;
  late final EventsModule events;
  late final TenantsModule tenants;

  VelixClient(this.config) {
    checkin = CheckinModule(this);
    persons = PersonsModule(this);
    events = EventsModule(this);
    tenants = TenantsModule(this);
  }

  Map<String, String> get _headers => {
        'x-api-key': config.apiKey,
        'Content-Type': 'application/json',
        'User-Agent': 'velix-dart-sdk/1.0.0',
      };

  Uri _uri(String path) => Uri.parse('${config.apiUrl}$path');

  dynamic _unwrap(Map<String, dynamic> body) => body['data'] ?? body;

  Future<dynamic> get(String path) => withRetry(
        () async {
          final res = await http
              .get(_uri(path), headers: _headers)
              .timeout(config.timeout);
          return _handleResponse(res);
        },
        maxRetries: config.maxRetries,
      );

  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      withRetry(
        () async {
          final res = await http
              .post(_uri(path), headers: _headers, body: jsonEncode(body))
              .timeout(config.timeout);
          return _handleResponse(res);
        },
        maxRetries: config.maxRetries,
      );

  Future<dynamic> put(String path, Map<String, dynamic> body) =>
      withRetry(
        () async {
          final res = await http
              .put(_uri(path), headers: _headers, body: jsonEncode(body))
              .timeout(config.timeout);
          return _handleResponse(res);
        },
        maxRetries: config.maxRetries,
      );

  Future<dynamic> patch(String path, Map<String, dynamic> body) =>
      withRetry(
        () async {
          final res = await http
              .patch(_uri(path), headers: _headers, body: jsonEncode(body))
              .timeout(config.timeout);
          return _handleResponse(res);
        },
        maxRetries: config.maxRetries,
      );

  Future<void> delete(String path) => withRetry(
        () async {
          final res = await http
              .delete(_uri(path), headers: _headers)
              .timeout(config.timeout);
          _handleResponse(res);
        },
        maxRetries: config.maxRetries,
      );

  dynamic _handleResponse(http.Response res) {
    if (res.statusCode == 401) throw const AuthException('Unauthorized');
    if (res.statusCode == 404) throw const NotFoundException('Not found');
    if (res.statusCode == 429) throw const RateLimitException();
    if (res.statusCode >= 400) {
      final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      throw VelixException(
        body['message'] ?? 'Request failed',
        statusCode: res.statusCode,
      );
    }
    if (res.body.isEmpty) return null;
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) return _unwrap(decoded);
    return decoded;
  }
}
