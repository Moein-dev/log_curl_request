import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
part 'curl_options.dart';
part 'log_curl_interceptor.dart';
part 'log_curl_config.dart';

/// A utility class to generate cURL commands for HTTP requests.
///
/// This class helps in debugging network requests by providing a cURL command
/// that can be executed directly in the terminal.
class LogCurlRequest {
  /// Validates the input parameters for the cURL command.
  ///
  /// Throws [ArgumentError] if the validation fails.
  static void _validateInput(String method, String path) {
    if (method.isEmpty) {
      throw ArgumentError('HTTP method cannot be empty');
    }
    if (path.isEmpty) {
      throw ArgumentError('URL path cannot be empty');
    }

    // Try to parse the URL to validate it
    try {
      final uri = Uri.parse(path);
      if (!uri.hasScheme) {
        throw ArgumentError('URL path must include a scheme (e.g., https://)');
      }
    } catch (e) {
      throw ArgumentError('Invalid URL path: $path. ${e.toString()}');
    }
  }

  /// Generates a cURL command based on the provided HTTP request details.
  ///
  /// [method]: The HTTP method (e.g., GET, POST, PUT, DELETE).
  /// [path]: The URL path of the request.
  /// [parameters]: Optional query parameters (key-value pairs).
  /// [data]: The request body data (supports Map or String).
  /// [headers]: Optional HTTP headers (key-value pairs).
  /// [showDebugPrint]: If `true`, prints the cURL command to the debug console.
  /// [cookies]: Optional cookies to include in the request.
  /// [formData]: Optional multipart form data for file uploads.
  /// [curlOptions]: Additional cURL command options.
  /// [maskSensitiveInfo]: If `true`, masks sensitive information like auth tokens.
  /// [formatOutput]: If `true`, adds line breaks for better readability.
  ///
  /// Returns the generated cURL command as a String.
  ///
  /// Throws [ArgumentError] if required parameters are invalid.
  static String create(
    String method,
    String path, {
    Map<String, dynamic>? parameters,
    dynamic data,
    Map<String, dynamic>? headers,
    bool? showDebugPrint,
    Map<String, String>? cookies,
    Map<String, dynamic>? formData,
    CurlOptions? curlOptions,
    bool? maskSensitiveInfo,
    bool? formatOutput,
  }) {
    // Validate required inputs
    _validateInput(method, path);

    // Apply defaults from config
    final config = LogCurlConfig.instance;
    final shouldShowDebugPrint = showDebugPrint ?? config.defaultShowDebugPrint;
    final shouldMaskSensitive = maskSensitiveInfo ?? config.defaultMaskSensitiveInfo;
    final shouldFormatOutput = formatOutput ?? config.defaultFormatOutput;
    
    // Merge with default curl options if provided
    if (config.defaultCurlOptions != null && curlOptions != null) {
      curlOptions = CurlOptions(
        insecure: curlOptions.insecure || config.defaultCurlOptions!.insecure,
        compressed: curlOptions.compressed || config.defaultCurlOptions!.compressed,
        verbose: curlOptions.verbose || config.defaultCurlOptions!.verbose,
        location: curlOptions.location || config.defaultCurlOptions!.location,
        maxTime: curlOptions.maxTime ?? config.defaultCurlOptions!.maxTime,
        customOptions: [
          ...config.defaultCurlOptions!.customOptions,
          ...curlOptions.customOptions,
        ],
      );
    } else if (config.defaultCurlOptions != null) {
      curlOptions = config.defaultCurlOptions;
    }

    final buffer = StringBuffer();
    final newLine = shouldFormatOutput ? '\\\n  ' : ' ';

    buffer.write('curl -X $method');
    
    // Apply curl options if specified
    if (curlOptions != null) {
      if (curlOptions.insecure) {
        buffer.write('$newLine--insecure');
      }
      if (curlOptions.compressed) {
        buffer.write('$newLine--compressed');
      }
      if (curlOptions.verbose) {
        buffer.write('$newLine--verbose');
      }
      if (curlOptions.location) {
        buffer.write('$newLine--location');
      }
      if (curlOptions.maxTime != null) {
        buffer.write('$newLine--max-time ${curlOptions.maxTime}');
      }
      // Add any custom options
      if (curlOptions.customOptions.isNotEmpty) {
        for (var option in curlOptions.customOptions) {
          buffer.write('$newLine$option');
        }
      }
    }

    // Add headers
    headers?.forEach((key, value) {
      // Mask sensitive header values if required
      final displayValue = _shouldMaskHeader(key, shouldMaskSensitive) 
          ? '********' 
          : value;
      buffer.write('$newLine-H "$key: $displayValue"');
    });

    // Add cookies
    if (cookies != null && cookies.isNotEmpty) {
      final cookieString = cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
      buffer.write('$newLine-b "$cookieString"');
    }

    // Handle multipart form data for file uploads
    if (formData != null && formData.isNotEmpty) {
      for (var entry in formData.entries) {
        if (entry.value is File) {
          final file = entry.value as File;
          buffer.write('$newLine-F "${entry.key}=@${file.path}"');
        } else {
          buffer.write('$newLine-F "${entry.key}=${entry.value}"');
        }
      }
    }
    // Add data if not already using form data
    else if (data != null) {
      if (data is Map) {
        try {
          buffer.write('$newLine--data \'${json.encode(data)}\'');
        } catch (e) {
          throw ArgumentError('Failed to encode data as JSON: ${e.toString()}');
        }
      } else if (data is String) {
        buffer.write('$newLine--data \'$data\'');
      } else {
        throw ArgumentError('Data must be either a Map or a String');
      }
    }

    // Add URL with parameters
    if (parameters != null && parameters.isNotEmpty) {
      try {
        final stringifiedParameters =
            parameters.map((key, value) => MapEntry(key, value.toString()));
        final queryString = Uri(queryParameters: stringifiedParameters).query;
        buffer.write('$newLine"$path?$queryString"');
      } catch (e) {
        throw ArgumentError('Failed to process query parameters: ${e.toString()}');
      }
    } else {
      buffer.write('$newLine"$path"');
    }

    final curlCommand = buffer.toString();

    // Log the cURL command
    if (shouldShowDebugPrint) {
      if (config.loggerFunction != null) {
        config.loggerFunction!("cURL command: \n$curlCommand\n");
      } else {
        debugPrint("cURL command: \n$curlCommand\n");
      }
    }

    // Return the cURL command
    return curlCommand;
  }

  /// Determines if a header value should be masked based on its key.
  static bool _shouldMaskHeader(String key, bool maskSensitiveInfo) {
    if (!maskSensitiveInfo) return false;
    
    return LogCurlConfig.instance.sensitiveHeaders
        .contains(key.toLowerCase());
  }
}
