import 'dart:convert';
import 'package:flutter/foundation.dart';

/// A utility class to generate cURL commands for HTTP requests.
///
/// This class helps in debugging network requests by providing a cURL command
/// that can be executed directly in the terminal.
class LogCurlRequest {
  /// Generates a cURL command based on the provided HTTP request details.
  ///
  /// [method]: The HTTP method (e.g., GET, POST, PUT, DELETE).
  /// [path]: The URL path of the request.
  /// [parameters]: Optional query parameters (key-value pairs).
  /// [data]: The request body data (supports Map or String).
  /// [headers]: Optional HTTP headers (key-value pairs).
  /// [showDebugPrint]: If `true`, prints the cURL command to the debug console.
  ///
  /// Returns the generated cURL command as a String.
  static String create(
    String method,
    String path, {
    Map<String, dynamic>? parameters,
    dynamic data,
    Map<String, dynamic>? headers,
    bool showDebugPrint = true,
  }) {
    final buffer = StringBuffer();

    buffer.write('curl -X $method');

    // Add headers
    headers?.forEach((key, value) {
      buffer.write(' -H "$key: $value"');
    });

    // Add data
    if (data != null) {
      if (data is Map) {
        buffer.write(" --data '${json.encode(data)}'");
      } else if (data is String) {
        buffer.write(" --data '$data'");
      }
    }

    // Add URL with parameters
    if (parameters != null && parameters.isNotEmpty) {
      final stringifiedParameters =
          parameters.map((key, value) => MapEntry(key, value.toString()));
      final queryString = Uri(queryParameters: stringifiedParameters).query;
      buffer.write(' "$path?$queryString"');
    } else {
      buffer.write(' "$path"');
    }

    // Log the cURL command
    if (showDebugPrint) {
      debugPrint("cURL command: \n ${buffer.toString()} \n");
    }

    // Return the cURL command
    return buffer.toString();
  }
}