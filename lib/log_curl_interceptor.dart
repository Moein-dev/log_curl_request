part of 'log_curl_request.dart';


/// A utility class to integrate with common HTTP client libraries.
class LogCurlInterceptor {
  /// Creates a cURL command from a Dio request.
  ///
  /// Requires the 'dio' package.
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