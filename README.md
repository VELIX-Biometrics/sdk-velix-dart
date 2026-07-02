# velix_sdk — Dart / Flutter SDK ![version](https://img.shields.io/badge/version-0.1.0--alpha.1-orange)

> ⚠️ **Alpha / pre-release.** This SDK targets the real API-key surface defined
> in `lib-velix-contracts/openapi/public-api.yaml` (task #593). It covers only
> the 6 endpoints that actually exist under `/v1/api/*` in `api-velix-identity-core`.
> Velix Time has NO endpoints on this surface — do not expect any `time`/`punch`
> functionality from this SDK.

Official Dart/Flutter SDK for the VELIX Biometrics platform — facial access control B2B SaaS.

## Requirements

- Dart 3.0+ / Flutter 3.10+
- Null safety

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  velix_sdk: ^0.1.0-alpha.1
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
  apiKey: Platform.environment['VELIX_API_KEY']!, // vlx_<hex>
));

final result = await client.checkin.identify(imageBase64: frameBase64);
print(result.matched ? 'MATCHED' : 'NOT MATCHED');
```

## Authentication

Every request sends `x-api-key: vlx_<hex>`. The backend also accepts
`Authorization: Bearer vlx_<hex>` as an alternative, but this SDK always uses
`x-api-key` and never any other auth header.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `VELIX_API_URL` | Yes | API base URL (`https://api.velixbiometrics.com`) |
| `VELIX_API_KEY` | Yes | Integrator API key (`vlx_...`) |

In Flutter, use a `.env` file with `flutter_dotenv` or pass via `--dart-define`:

```bash
flutter run --dart-define=VELIX_API_URL=https://... --dart-define=VELIX_API_KEY=vlx_...
```

## Modules

| Module | Endpoint | Scope | Methods |
|--------|----------|-------|---------|
| `client.onboarding` | `POST /v1/api/onboarding` | `onboarding:write` | `enroll()` |
| `client.checkin` | `POST /v1/api/checkin/identify` | `checkin:write` | `identify()` |
| `client.lgpd` | `POST /v1/api/deletion-request` | `lgpd:write` | `requestDeletion()` |
| `client.me` | `GET /v1/api/me/{personId}` | `me:read` | `get()` |
| `client.events` | `POST /v1/api/events/{id}/guests`, `GET /v1/api/events/{id}/guests/{guestId}` | `events:write`, `events:read` | `createGuest()`, `getGuest()` |

Every response comes wrapped in `{"data": ...}` on the wire — the SDK
unwraps the envelope internally and only ever exposes the unwrapped payload.

## Onboarding Module

```dart
final result = await client.onboarding.enroll(
  name: 'João Silva',
  frames: [frame1, frame2, frame3], // base64 JPEG, no data URI prefix
  email: 'joao@company.com',
  externalId: 'EMP-001',
);
// result.personId, result.identityId, result.enrolled, result.framesProcessed
```

## Checkin Module

```dart
final result = await client.checkin.identify(
  imageBase64: frameBase64,
  topK: 3,
  liveness: LivenessBlock(
    token: challengeToken, // from the public HMAC challenge endpoint
    samples: [LivenessSample(action: 'center', imageBase64: sampleFrame)],
  ),
  location: CheckinLocation(latitude: -23.55, longitude: -46.63),
);
// result.matched, result.personId, result.qualityScore
// NOTE: the liveness score is NEVER returned by the API — only `passed`
// booleans are exposed elsewhere; here only matched/quality_score/message.
```

There is no QR/PIN checkin mode on this API-key surface — only facial
identify is exposed under `/v1/api/*`.

## LGPD Module

```dart
final result = await client.lgpd.requestDeletion(personId);
// result.protocolNumber, result.message
```

## Me Module

```dart
final me = await client.me.get(personId);
// me.name, me.email, me.phone, me.photoUrl, me.createdAt
```

## Events Module

```dart
final guest = await client.events.createGuest(
  eventId,
  name: 'Maria Silva',
  email: 'maria@empresa.com',
);
final fetched = await client.events.getGuest(eventId, guest.id!);
// guest.id, guest.eventId, guest.status, guest.categoryId
```

Only guest create/read are exposed on this surface — there is no event
listing/creation/config API for API-key integrators.

## Velix Time

Velix Time has no endpoints on the `/v1/api/*` API-key surface (see
`x-velix-sdk-contract-notes` in the OpenAPI spec — `time:read`/`time:write`
scopes are reserved but unimplemented). This SDK exposes no `time`/`punch`
module; do not add one until the backend gap is addressed (task #616).

## Error Handling

```dart
import 'package:velix_sdk/velix_sdk.dart';

try {
  final result = await client.checkin.identify(imageBase64: frame);
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
  final String frameBase64;

  const CheckinButton({required this.client, required this.frameBase64, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await client.checkin.identify(imageBase64: frameBase64);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.matched ? 'Access granted' : 'Access denied')),
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
