#!/usr/bin/env bash
set -e
dart pub get
dart run smoke_test.dart
