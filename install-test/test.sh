#!/usr/bin/env bash
# `dart pub publish --dry-run` valida exatamente o que entraria no
# pacote publicado (arquivos incluídos, pubspec válido). Depois um
# projeto separado consome via dependency override apontando pro path —
# mais simples que simular um servidor pub privado, mas ainda assim
# valida resolução de pacote fora do próprio repo.
set -e
cd "$(dirname "$0")/.."
REPO_DIR="$(pwd)"

dart pub get
dart pub publish --dry-run 2>&1 | tail -5

rm -rf /tmp/velix-install-test-dart
mkdir -p /tmp/velix-install-test-dart/bin
cd /tmp/velix-install-test-dart

cat > pubspec.yaml <<EOF
name: velix_install_test
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  velix_sdk:
    path: $REPO_DIR
EOF

cat > bin/main.dart <<'EOF'
import 'package:velix_sdk/velix_sdk.dart';

void main() {
  final client = VelixClient(VelixConfig(apiUrl: 'http://localhost', apiKey: 'test'));
  if (client.onboarding == null) {
    throw Exception('client.onboarding null no pacote instalado');
  }
  print('INSTALL_TEST:dart:PASS: resolvido via pub path dependency, client.onboarding existe');
}
EOF

dart pub get
dart run bin/main.dart
