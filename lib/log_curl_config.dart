part of 'log_curl_request.dart';

/// Global configuration for LogCurlRequest.
class LogCurlConfig {
  /// Default instance of the configuration.
  static final LogCurlConfig instance = LogCurlConfig();

  /// Default value for showing debug print.
  bool defaultShowDebugPrint;

  /// Default value for masking sensitive information.
  bool defaultMaskSensitiveInfo;

  /// Default value for formatted output.
  bool defaultFormatOutput;

  /// Default curl options to apply to all requests.
  CurlOptions? defaultCurlOptions;

  /// List of headers that should be considered sensitive and masked.
  List<String> sensitiveHeaders;

  /// Custom logger function that will be used instead of debugPrint if provided.
  void Function(String message)? loggerFunction;

  /// Creates a configuration instance with default values.
  LogCurlConfig({
    this.defaultShowDebugPrint = true,
    this.defaultMaskSensitiveInfo = false,
    this.defaultFormatOutput = false,
    this.defaultCurlOptions,
    List<String>? sensitiveHeaders,
    this.loggerFunction,
  }) : sensitiveHeaders = sensitiveHeaders ??
            [
              'authorization',
              'api-key',
              'apikey',
              'x-api-key',
              'token',
              'secret',
              'password',
              'access-token',
              'refresh-token',
              'session-token',
            ];

  /// Reset the configuration to default values.
  void reset() {
    defaultShowDebugPrint = true;
    defaultMaskSensitiveInfo = false;
    defaultFormatOutput = false;
    defaultCurlOptions = null;
    sensitiveHeaders = [
      'authorization',
      'api-key',
      'apikey',
      'x-api-key',
      'token',
      'secret',
      'password',
      'access-token',
      'refresh-token',
      'session-token',
    ];
    loggerFunction = null;
  }
}
