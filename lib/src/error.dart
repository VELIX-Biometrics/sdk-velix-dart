class VelixException implements Exception {
  final String message;
  final int? statusCode;

  const VelixException(this.message, {this.statusCode});

  @override
  String toString() => 'VelixException($statusCode): $message';
}

class AuthException extends VelixException {
  const AuthException(super.message) : super(statusCode: 401);
}

class BiometricException extends VelixException {
  final String? code;
  const BiometricException(super.message, {this.code, super.statusCode});
}

class RateLimitException extends VelixException {
  final Duration? retryAfter;
  const RateLimitException({this.retryAfter})
      : super('Rate limit exceeded', statusCode: 429);
}

class NotFoundException extends VelixException {
  const NotFoundException(super.message) : super(statusCode: 404);
}
