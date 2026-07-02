# velix_sdk — Dart / Flutter SDK ![version](https://img.shields.io/badge/version-0.1.0--alpha.1-orange)

> ⚠️ **Alpha / pre-release.** This SDK targets a public API surface that does not yet fully exist on the VELIX backend (see internal task #593). Endpoints and auth may not work against production. Do not use in production integrations yet.

Official Dart/Flutter SDK for the VELIX Biometrics platform — facial access control B2B SaaS.

## Requirements

- Dart 3.0+ / Flutter 3.10+
- Null safety

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  velix_sdk: ^1.0.0
```

Then:

```bash
dart pub get
# or
flutter pub get
```

## Quick Start

```dart
import 'package:velix_sdk/velix_sdk.dart';

final client = VelixClient(VelixConfig(
  apiUrl: Platform.environment['VELIX_API_URL']!,
  apiKey: Platform.environment['VELIX_API_KEY']!,
));

final result = await client.checkin.facial('tenant-slug', frameBase64);
print(result.passed ? 'GRANTED' : 'DENIED');
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `VELIX_API_URL` | Yes | API base URL (`https://api.velixbiometrics.com`) |
| `VELIX_API_KEY` | Yes | Tenant API key (`vx_live_...` or `vx_sandbox_...`) |

In Flutter, use a `.env` file with `flutter_dotenv` or pass via `--dart-define`:

```bash
flutter run --dart-define=VELIX_API_URL=https://... --dart-define=VELIX_API_KEY=vx_live_...
```

## Modules

| Module | Methods |
|--------|---------|
| `client.checkin` | `facial()`, `qr()`, `pin()`, `getHistory()` |
| `client.persons` | `list()`, `get()`, `create()`, `update()`, `delete()`, `enroll()` |
| `client.events` | `list()`, `get()`, `create()`, `configure()` |
| `client.tenants` | `me()`, `updateSettings()` |

## Checkin Module

```dart
// Facial identification (base64 JPEG frame)
final result = await client.checkin.facial('tenant-slug', frameBase64);
// result.passed      == true
// result.personId    == 'uuid'
// result.personName  == 'João Silva'

// QR code checkin
final result = await client.checkin.qr('tenant-slug', qrToken);

// PIN checkin
final result = await client.checkin.pin('tenant-slug', pin);

// Paginated history
final history = await client.checkin.getHistory('tenant-slug', page: 1, limit: 20);
```

## Persons Module

```dart
// List with optional search
final list = await client.persons.list(page: 1, limit: 20, search: 'João');

// Get by ID
final person = await client.persons.get('uuid');

// Create
final created = await client.persons.create({
  'name':       'João Silva',
  'email':      'joao@company.com',
  'externalId': 'EMP-001',
});

// Update
await client.persons.update('uuid', {'name': 'João B. Silva'});

// Enroll biometrics (minimum 3 base64 frames)
await client.persons.enroll('uuid', [frame1, frame2, frame3]);

// Delete
await client.persons.delete('uuid');
```

## Events Module

```dart
final list    = await client.events.list(page: 1, limit: 20);
final event   = await client.events.get('uuid');
final created = await client.events.create({'name': 'Annual Conference 2026'});
await client.events.configure('uuid', {'checkInOpen': true});
```

## Tenants Module

```dart
final tenant = await client.tenants.me();
await client.tenants.updateSettings({'requireLiveness': true});
```

## Error Handling

```dart
import 'package:velix_sdk/velix_sdk.dart';

try {
  final result = await client.checkin.facial('slug', frame);
} on AuthException {
  print('Invalid API key');
} on BiometricException catch (e) {
  print('Face not recognized: ${e.message}');
} on RateLimitException catch (e) {
  print('Rate limit — retry after ${e.retryAfter}ms');
} on VelixException catch (e) {
  print('HTTP ${e.statusCode}: ${e.message}');
}
```

## Flutter Widget Example

```dart
class CheckinButton extends StatelessWidget {
  final VelixClient client;
  final String tenantSlug;
  final String frameBase64;

  const CheckinButton({required this.client, required this.tenantSlug, required this.frameBase64, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await client.checkin.facial(tenantSlug, frameBase64);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.passed ? 'Access granted' : 'Access denied')),
        );
      },
      child: const Text('Check In'),
    );
  }
}
```

## Running Tests

```bash
dart test
dart test test/checkin_test.dart    # single file
dart test --coverage=coverage/      # with coverage
```

## Local Development

```bash
dart pub get
dart analyze
dart test
dart format .
```

## Get an API Key

Access the dashboard at **velixbiometrics.com** → Settings → API Keys → New Key.
