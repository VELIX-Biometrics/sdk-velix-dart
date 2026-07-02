class VelixConfig {
  final String apiUrl;
  final String apiKey;
  final Duration timeout;
  final int maxRetries;

  const VelixConfig({
    required this.apiUrl,
    required this.apiKey,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
  });
}
