class AppConfig {
  AppConfig._();

  /// Base URL for the API. Swap to a real backend when available.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.careconnect.example.com/v1',
  );

  /// When true, repositories serve in-memory mock data instead of hitting the
  /// network. Useful for running the app without a backend.
  static const bool useMockData = true;

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Simulated latency for mock data sources, so loading states are visible.
  static const Duration mockLatency = Duration(milliseconds: 700);
}
