/// A Flutter package to log HTTP requests in cURL format for debugging and testing purposes.
/// 
/// This library provides utilities to generate cURL commands from HTTP request details,
/// making it easier to debug and share API calls during development.
/// 
/// Main features:
/// - Generate cURL commands for HTTP requests
/// - Support for all HTTP methods (GET, POST, PUT, DELETE, etc.)
/// - Handle headers, query parameters, and request bodies
/// - Support for file uploads via multipart form data
/// - Cookie handling and cURL options
/// - Mask sensitive information like auth tokens
/// - Integration with popular HTTP client libraries
/// - Global configuration for consistent behavior
library log_curl_request;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'curl_options.dart';
import 'log_curl_config.dart';

export 'curl_options.dart';
export 'log_curl_config.dart';

/// A utility class to generate cURL commands for HTTP requests.
///
/// This class helps in debugging network requests by providing a cURL command
/// that can be executed directly in the terminal. It supports various HTTP
/// methods, headers, request bodies, query parameters, cookies, file uploads,
/// and advanced cURL options.
///
/// The generated cURL commands can be used for:
/// - Testing API endpoints outside of your application
/// - Sharing reproducible HTTP requests with team members
/// - Debugging network issues
/// - Documentation and examples
///
/// Example usage:
/// ```dart
/// final curlCommand = LogCurlRequest.create(
///   'POST',
///   'https://api.example.com/users',
///   headers: {'Content-Type': 'application/json'},
///   data: {'name': 'John Doe', 'email': 'john@example.com'},
///   showDebugPrint: true,
/// );
/// print(curlCommand);
/// ```
class LogCurlRequest {
  /// Validates the input parameters for the cURL command.
  ///
  /// Performs comprehensive validation of required parameters to ensure
  /// a valid cURL command can be generated.
  ///
  /// Validations performed:
  /// - [method]: Must not be empty
  /// - [path]: Must not be empty and must be a valid URL with scheme
  ///
  /// Throws [ArgumentError] if any validation fails with a descriptive message.
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
  /// This is the main method for creating cURL commands. It accepts various
  /// parameters to customize the HTTP request and returns a complete cURL
  /// command string that can be executed in a terminal.
  ///
  /// Parameters:
  /// - [method]: The HTTP method (e.g., GET, POST, PUT, DELETE, PATCH).
  /// - [path]: The complete URL of the request (must include scheme like https://).
  /// - [parameters]: Optional query parameters as key-value pairs.
  /// - [data]: The request body data. Accepts Map (converted to JSON) or String.
  /// - [headers]: Optional HTTP headers as key-value pairs.
  /// - [showDebugPrint]: If `true`, prints the cURL command to the debug console.
  ///   Uses global config default if not specified.
  /// - [cookies]: Optional cookies to include in the request as key-value pairs.
  /// - [formData]: Optional multipart form data for file uploads. Values can be
  ///   File objects (for file uploads) or any other type (for form fields).
  /// - [curlOptions]: Additional cURL command options (SSL, compression, etc.).
  /// - [maskSensitiveInfo]: If `true`, masks sensitive information like auth tokens.
  ///   Uses global config default if not specified.
  /// - [formatOutput]: If `true`, adds line breaks for better readability.
  ///   Uses global config default if not specified.
  ///
  /// Returns the generated cURL command as a String.
  ///
  /// Throws [ArgumentError] if:
  /// - Required parameters are invalid (empty method/path, invalid URL)
  /// - Data cannot be JSON-encoded
  /// - Query parameters cannot be processed
  /// - Data type is not Map or String
  ///
  /// Example:
  /// ```dart
  /// final curlCommand = LogCurlRequest.create(
  ///   'POST',
  ///   'https://api.example.com/users',
  ///   headers: {
  ///     'Content-Type': 'application/json',
  ///     'Authorization': 'Bearer token123',
  ///   },
  ///   data: {
  ///     'name': 'John Doe',
  ///     'email': 'john@example.com',
  ///   },
  ///   parameters: {'lang': 'en'},
  ///   showDebugPrint: true,
  ///   maskSensitiveInfo: true,
  ///   formatOutput: true,
  /// );
  /// ```
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
      curlOptions = curlOptions.copyWith(
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
  /// 
  /// This helper method checks if a header name matches any of the
  /// sensitive headers defined in the global configuration.
  /// 
  /// Parameters:
  /// - [key]: The header name to check (case-insensitive)
  /// - [maskSensitiveInfo]: Whether masking is enabled
  /// 
  /// Returns true if the header should be masked, false otherwise.
  static bool _shouldMaskHeader(String key, bool maskSensitiveInfo) {
    if (!maskSensitiveInfo) return false;
    
    return LogCurlConfig.instance.sensitiveHeaders
        .contains(key.toLowerCase());
  }
}

/// A utility class to integrate with common HTTP client libraries.
/// 
/// This class provides static methods to create cURL commands from
/// request objects of popular HTTP client libraries like Dio and the
/// standard http package. This enables easy logging of HTTP requests
/// in cURL format without manual parameter extraction.
class LogCurlInterceptor {
  /// Creates a cURL command from a Dio request.
  ///
  /// This method extracts request information from a Dio RequestOptions object
  /// and generates the corresponding cURL command. This is typically used in
  /// Dio interceptors to log outgoing requests.
  ///
  /// Requires the 'dio' package to be installed in your project.
  /// 
  /// Parameters:
  /// - [options]: The Dio RequestOptions object (should be of type RequestOptions)
  /// - [showDebugPrint]: Whether to print the command to debug console
  /// - [maskSensitiveInfo]: Whether to mask sensitive header values
  /// - [formatOutput]: Whether to format with line breaks for readability
  /// - [curlOptions]: Additional cURL options to include
  /// 
  /// Returns the generated cURL command as a String, or an error message
  /// if the operation fails.
  /// 
  /// Example:
  /// ```dart
  /// // In your Dio setup
  /// dio.interceptors.add(
  ///   InterceptorsWrapper(
  ///     onRequest: (options, handler) {
  ///       LogCurlInterceptor.fromDioRequest(options);
  ///       return handler.next(options);
  ///     },
  ///   ),
  /// );
  /// ```
  static String fromDioRequest(dynamic options, {
    bool? showDebugPrint,
    bool? maskSensitiveInfo,
    bool? formatOutput,
    CurlOptions? curlOptions,
  }) {
    if (options == null) return '';
    
    try {
      // Note: This implementation assumes you have dio package
      // and the options object is of type RequestOptions
      final method = options.method?.toString().toUpperCase() ?? 'GET';
      final path = options.uri?.toString() ?? options.path?.toString() ?? '';
      Map<String, dynamic>? headers = options.headers;
      dynamic data = options.data;
      Map<String, dynamic>? queryParameters = options.queryParameters;

      return LogCurlRequest.create(
        method,
        path,
        headers: headers,
        data: data,
        parameters: queryParameters,
        showDebugPrint: showDebugPrint,
        maskSensitiveInfo: maskSensitiveInfo,
        formatOutput: formatOutput,
        curlOptions: curlOptions,
      );
    } catch (e) {
      debugPrint('Error creating cURL from Dio request: ${e.toString()}');
      return 'Error creating cURL from Dio request: ${e.toString()}';
    }
  }

  /// Creates a cURL command from an 'http' package request.
  ///
  /// This method extracts request information from an http.Request object
  /// and generates the corresponding cURL command. This is useful for logging
  /// requests made with the standard Dart http package.
  ///
  /// Requires the 'http' package to be installed in your project.
  ///
  /// Parameters:
  /// - [request]: The http.Request object (should be of type http.Request)
  /// - [showDebugPrint]: Whether to print the command to debug console
  /// - [maskSensitiveInfo]: Whether to mask sensitive header values
  /// - [formatOutput]: Whether to format with line breaks for readability
  /// - [curlOptions]: Additional cURL options to include
  /// 
  /// Returns the generated cURL command as a String, or an error message
  /// if the operation fails.
  ///
  /// Example:
  /// ```dart
  /// final request = http.Request('GET', Uri.parse('https://example.com'));
  /// request.headers['Content-Type'] = 'application/json';
  /// 
  /// // Log the cURL command before sending
  /// LogCurlInterceptor.fromHttpRequest(request);
  /// 
  /// final response = await request.send();
  /// ```
  static String fromHttpRequest(dynamic request, {
    bool? showDebugPrint,
    bool? maskSensitiveInfo,
    bool? formatOutput,
    CurlOptions? curlOptions,
  }) {
    if (request == null) return '';
    
    try {
      // Note: This implementation assumes you have http package
      // and the request object is of type http.Request
      final method = request.method.toUpperCase();
      final path = request.url.toString();
      Map<String, dynamic> headers = Map<String, dynamic>.from(request.headers);
      
      // Get the body data if available
      dynamic data;
      if (request.body.isNotEmpty) {
        try {
          // Try to parse as JSON
          data = json.decode(request.body);
        } catch (e) {
          // If not JSON, use as string
          data = request.body;
        }
      }

      return LogCurlRequest.create(
        method,
        path,
        headers: headers,
        data: data,
        showDebugPrint: showDebugPrint,
        maskSensitiveInfo: maskSensitiveInfo,
        formatOutput: formatOutput,
        curlOptions: curlOptions,
      );
    } catch (e) {
      debugPrint('Error creating cURL from HTTP request: ${e.toString()}');
      return 'Error creating cURL from HTTP request: ${e.toString()}';
    }
  }
}
