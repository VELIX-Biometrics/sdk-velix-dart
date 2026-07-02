#!/usr/bin/env dart
import 'dart:io';
import 'lib/velix_sdk.dart';

const img = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';

void result(String step, bool ok, String detail) {
  print('RESULT:dart:$step:${ok ? 'PASS' : 'FAIL'}:$detail');
}

bool reachable(String msg) {
  final m = msg.toLowerCase();
  return !['route not found', 'no route', '401', '403'].any((s) => m.contains(s));
}

Future<void> main() async {
  final client = VelixClient(VelixConfig(
    apiUrl: Platform.environment['API_BASE_URL']!,
    apiKey: Platform.environment['VELIX_API_KEY']!,
  ));

  String? personId;
  try {
    final r = await client.onboarding.enroll(name: 'Smoke Test Dart', frames: [img, img, img]);
    personId = r.personId;
    result('onboarding', personId != null, 'person_id=$personId');
  } catch (e) {
    result('onboarding', false, '$e');
  }

  try {
    final r = await client.checkin.identify(imageBase64: img);
    result('checkin', true, 'matched=${r.matched}');
  } catch (e) {
    result('checkin', false, '$e');
  }

  if (personId != null) {
    try {
      await client.lgpd.requestDeletion(personId);
      result('lgpd', true, 'deletion-request ok');
    } catch (e) {
      result('lgpd', false, '$e');
    }
    try {
      await client.me.get(personId);
      result('me', true, 'got response');
    } catch (e) {
      result('me', false, '$e');
    }
  }

  const dummy = '00000000-0000-0000-0000-000000000000';
  try {
    await client.events.createGuest(dummy, name: 'Guest Smoke', email: 'guest@smoke.test');
    result('events_create', true, 'endpoint reachable');
  } catch (e) {
    result('events_create', reachable('$e'), '$e');
  }

  try {
    await client.events.getGuest(dummy, dummy);
    result('events_get', true, 'endpoint reachable');
  } catch (e) {
    result('events_get', reachable('$e'), '$e');
  }
}
