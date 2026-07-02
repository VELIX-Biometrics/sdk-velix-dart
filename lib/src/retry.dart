import 'dart:math';
import 'error.dart';

Future<T> withRetry<T>(
  Future<T> Function() fn, {
  int maxRetries = 3,
}) async {
  int attempt = 0;
  while (true) {
    try {
      return await fn();
    } on VelixException catch (e) {
      attempt++;
      final retryable = e.statusCode == 429 || e.statusCode == 503;
      if (!retryable || attempt >= maxRetries) rethrow;
      final delay = Duration(milliseconds: (200 * pow(2, attempt)).toInt());
      await Future.delayed(delay);
    }
  }
}
