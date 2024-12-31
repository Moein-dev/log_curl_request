import 'dart:convert';
import 'package:flutter/foundation.dart';

class LogCurlRequest {
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
      final queryString = Uri(queryParameters: parameters).query;
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