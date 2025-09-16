import 'curl_options.dart';

/// Global configuration for LogCurlRequest.
/// 
/// This class manages global settings that affect the behavior of all
/// LogCurlRequest.create() calls unless overridden by specific parameters.
/// Use the singleton instance to configure default behaviors across your application.
class LogCurlConfig {
  /// Default instance of the configuration.
  /// 
  /// This singleton instance is used by LogCurlRequest.create() to apply
  /// default values when specific parameters are not provided.
  static final LogCurlConfig instance = LogCurlConfig();

  /// Default value for showing debug print.
  /// 
  /// When true, cURL commands will be printed to the debug console
  /// by default unless overridden in individual create() calls.
  bool defaultShowDebugPrint;

  /// Default value for masking sensitive information.
  /// 
  /// When true, sensitive header values (like authorization tokens)
  /// will be masked with asterisks by default.
  bool defaultMaskSensitiveInfo;

  /// Default value for formatted output.
  /// 
  /// When true, cURL commands will be formatted with line breaks
  /// for better readability by default.
  bool defaultFormatOutput;

  /// Default curl options to apply to all requests.
  /// 
  /// These options will be merged with any options provided
  /// in individual create() calls.
  CurlOptions? defaultCurlOptions;

  /// List of headers that should be considered sensitive and masked.
  /// 
  /// Header names in this list (case-insensitive) will have their
  /// values replaced with asterisks when maskSensitiveInfo is true.
  List<String> sensitiveHeaders;

  /// Custom logger function that will be used instead of debugPrint if provided.
  /// 
  /// When set, this function will be called to log cURL commands instead
  /// of using Flutter's debugPrint. Useful for integrating with custom
  /// logging frameworks or analytics services.
  void Function(String message)? loggerFunction;

  /// Creates a configuration instance with default values.
  /// 
  /// Default configuration:
  /// - [defaultShowDebugPrint]: true (commands are logged by default)
  /// - [defaultMaskSensitiveInfo]: false (sensitive info is not masked by default)
  /// - [defaultFormatOutput]: false (compact output by default)
  /// - [defaultCurlOptions]: null (no default cURL options)
  /// - [sensitiveHeaders]: Pre-defined list of common sensitive header names
  /// - [loggerFunction]: null (uses debugPrint by default)
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
  /// 
  /// This method restores all configuration settings to their
  /// initial default values, clearing any custom configuration
  /// that was applied.
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
