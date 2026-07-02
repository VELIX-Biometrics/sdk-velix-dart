import 'dart:convert';
import 'package:test/test.dart';
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  group('TenantsModule', () {
    test('Tenant.fromJson parses correctly', () {
      final json = {
        'id': 'tenant-uuid',
        'name': 'Acme Corp',
        'slug': 'acme',
        'plan': 'enterprise',
        'maxPersons': 1000,
      };
      final tenant = Tenant.fromJson(json);
      expect(tenant.id, equals('tenant-uuid'));
      expect(tenant.slug, equals('acme'));
      expect(tenant.plan, equals('enterprise'));
      expect(tenant.maxPersons, equals(1000));
    });

    test('Tenant.copyWith preserves unset fields', () {
      const original = Tenant(id: 't1', name: 'Acme', slug: 'acme', plan: 'starter');
      final updated = original.copyWith(plan: 'enterprise');
      expect(updated.plan, equals('enterprise'));
      expect(updated.slug, equals('acme'));
      expect(updated.id, equals('t1'));
    });

    test('UpdateTenantSettingsRequest serializes correctly', () {
      final req = UpdateTenantSettingsRequest(
        requireLiveness: true,
        timezone: 'America/Sao_Paulo',
      );
      final json = req.toJson();
      expect(json['requireLiveness'], isTrue);
      expect(json['timezone'], equals('America/Sao_Paulo'));
    });

    test('Tenant.fromJson handles null optional fields', () {
      final json = {'id': 't1', 'name': 'Corp', 'slug': 'corp', 'plan': 'free'};
      final tenant = Tenant.fromJson(json);
      expect(tenant.id, equals('t1'));
      expect(tenant.timezone, isNull);
    });
  });
}
