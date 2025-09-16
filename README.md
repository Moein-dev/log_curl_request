# LogCurlRequest - Flutter Package

## Introduction

**LogCurlRequest** is a Flutter package designed to streamline the creation of `cURL` commands from your HTTP request details. This package provides developers with a simple and effective way to log HTTP requests as `cURL` commands, facilitating debugging and sharing of API calls.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Example](#example)
- [Advanced Features](#advanced-features)
  - [File Uploads](#file-uploads)
  - [Cookies](#cookies)
  - [cURL Options](#curl-options)
  - [Masking Sensitive Information](#masking-sensitive-information)
  - [Formatted Output](#formatted-output)
  - [HTTP Client Integration](#http-client-integration)
- [Global Configuration](#global-configuration)
  - [Custom Logging](#custom-logging)
  - [Default Settings](#default-settings)
- [Error Handling](#error-handling)
- [Configuration Parameters](#configuration-parameters)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
- [Contributors](#contributors)
- [License](#license)

## Features

- Generate `cURL` commands for HTTP requests.
- Support for all major HTTP methods (GET, POST, PUT, DELETE, etc.).
- Add HTTP headers, body data (JSON or plain text), and query parameters.
- Support for file uploads via multipart form data.
- Cookie handling with simple key-value pairs.
- Additional cURL options like --insecure, --compressed, --verbose, etc.
- Mask sensitive information like auth tokens and API keys.
- Format output with line breaks for better readability.
- Integration with popular HTTP client libraries (Dio, http).
- Global configuration for consistent behavior.
- Custom logging functionality.
- Robust input validation and error handling.
- Shell-safe escaping of special characters to prevent command injection.
- Optionally log the generated `cURL` command using Flutter's `debugPrint`.

## Installation

To use this package, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  log_curl_request: ^0.1.1
```

Then, run:

```bash
flutter pub get
```

## Usage

Import the package into your Dart file:

```dart
import 'package:log_curl_request/log_curl_request.dart';
```

Generate a basic `cURL` command:

```dart
String curlCommand = LogCurlRequest.create(
  "POST",
  "https://api.example.com/resource",
  parameters: {"key": "value"},
  data: {"field": "value"},
  headers: {"Authorization": "Bearer YOUR_TOKEN"},
  showDebugPrint: true,
);
```

This will generate and optionally log a `cURL` command like:

```bash
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" --data '{"field":"value"}' "https://api.example.com/resource?key=value"
```

## Example

Here's a basic example of using the package:

```dart
void main() {
  String curlCommand = LogCurlRequest.create(
    "GET",
    "https://api.example.com/users",
    parameters: {"page": "1", "limit": "10"},
    headers: {"Content-Type": "application/json"},
    showDebugPrint: true,
  );

  print(curlCommand);
}
```

Expected Output (logged via `debugPrint`):

```bash
cURL command: 
curl -X GET -H "Content-Type: application/json" "https://api.example.com/users?page=1&limit=10"
```

## Advanced Features

### File Uploads

You can use the `formData` parameter to simulate file uploads:

```dart
import 'dart:io';

final file = File('/path/to/file.jpg');
String curlCommand = LogCurlRequest.create(
  "POST",
  "https://api.example.com/upload",
  formData: {
    "file": file,
    "description": "My uploaded file",
  },
);
```

This will generate a command like:

```bash
curl -X POST -F "file=@/path/to/file.jpg" -F "description=My uploaded file" "https://api.example.com/upload"
```

### Cookies

To include cookies in your request:

```dart
String curlCommand = LogCurlRequest.create(
  "GET",
  "https://api.example.com/profile",
  cookies: {
    "session": "abc123",
    "theme": "dark",
  },
);
```

This will generate:

```bash
curl -X GET -b "session=abc123; theme=dark" "https://api.example.com/profile"
```

### cURL Options

You can specify additional cURL options:

```dart
String curlCommand = LogCurlRequest.create(
  "GET",
  "https://api.example.com/secure",
  curlOptions: CurlOptions(
    insecure: true,
    compressed: true,
    verbose: true,
    location: true,
    maxTime: 30,
    customOptions: ["--http2"],
  ),
);
```

This will generate:

```bash
curl -X GET --insecure --compressed --verbose --location --max-time 30 --http2 "https://api.example.com/secure"
```

### Masking Sensitive Information

To mask sensitive information like authorization tokens:

```dart
String curlCommand = LogCurlRequest.create(
  "GET",
  "https://api.example.com/user",
  headers: {
    "Authorization": "Bearer secret-token-12345",
    "x-api-key": "private-api-key",
  },
  maskSensitiveInfo: true,
);
```

This will generate:

```bash
curl -X GET -H "Authorization: ********" -H "x-api-key: ********" "https://api.example.com/user"
```

### Formatted Output

For better readability, especially for complex requests:

```dart
String curlCommand = LogCurlRequest.create(
  "POST",
  "https://api.example.com/complex",
  headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer token",
  },
  data: {"key": "value"},
  formatOutput: true,
);
```

This will generate:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer token" \
  --data '{"key":"value"}' \
  "https://api.example.com/complex"
```

### HTTP Client Integration

The package provides interceptors for popular HTTP clients:

#### Dio

```dart
import 'package:dio/dio.dart';

final dio = Dio();
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      LogCurlInterceptor.fromDioRequest(
        options,
        formatOutput: true,
        maskSensitiveInfo: true,
      );
      return handler.next(options);
    },
  ),
);
```

#### HTTP Package

```dart
import 'package:http/http.dart' as http;

final request = http.Request('GET', Uri.parse('https://example.com'));
request.headers['Content-Type'] = 'application/json';

// Log the cURL command before sending
LogCurlInterceptor.fromHttpRequest(
  request,
  formatOutput: true,
  maskSensitiveInfo: true,
);

final response = await request.send();
```

## Global Configuration

You can set up global configuration for consistent behavior across your app:

```dart
void main() {
  // Configure once at the start of your app
  LogCurlConfig.instance.defaultShowDebugPrint = true;
  LogCurlConfig.instance.defaultMaskSensitiveInfo = true;
  LogCurlConfig.instance.defaultFormatOutput = true;
  LogCurlConfig.instance.defaultCurlOptions = CurlOptions(
    insecure: true,
    compressed: true,
  );
  
  // Add custom sensitive headers if needed
  LogCurlConfig.instance.sensitiveHeaders.add('my-custom-auth-header');
  
  // Now any call to LogCurlRequest.create will use these defaults
  // unless overridden in the specific call
  runApp(MyApp());
}
```

### Custom Logging

You can customize how cURL commands are logged:

```dart
// Define a custom logger
LogCurlConfig.instance.loggerFunction = (message) {
  // Use your own logging framework
  MyLogger.debug(message);
  
  // Or save to a file
  LogFile.append(message);
  
  // Or send to a remote logging service
  AnalyticsService.logNetworkRequest(message);
};
```

### Default Settings

Creating a custom configuration:

```dart
// Create a custom configuration
final config = LogCurlConfig(
  defaultShowDebugPrint: false,
  defaultMaskSensitiveInfo: true,
  defaultFormatOutput: true,
  sensitiveHeaders: ['authorization', 'x-api-key', 'my-custom-header'],
  loggerFunction: (message) => print('NETWORK: $message'),
);

// Set as the global instance
LogCurlConfig.instance = config;
```

## Error Handling

The package provides robust error handling for common problems:

```dart
try {
  final curlCommand = LogCurlRequest.create(
    "POST",
    "https://api.example.com",
    data: complexObject, // Could cause a JSON encoding error
  );
} catch (e) {
  if (e is ArgumentError) {
    print('Invalid request parameters: ${e.message}');
  } else {
    print('An unexpected error occurred: $e');
  }
}
```

Common validation errors:
- Empty method or URL
- Invalid URL format (missing scheme)
- Invalid data type (not Map or String)
- JSON encoding failure for data
- Query parameter processing errors

## Configuration Parameters

- **method**: The HTTP method (e.g., `GET`, `POST`).
- **path**: The API endpoint (must be a valid URL with scheme).
- **parameters**: (Optional) Query parameters as a `Map<String, dynamic>`.
- **data**: (Optional) The request body (supports `Map` or `String`).
- **headers**: (Optional) HTTP headers as a `Map<String, dynamic>`.
- **showDebugPrint**: (Optional) A boolean to enable logging of the generated `cURL` command.
- **cookies**: (Optional) Cookies as a `Map<String, String>`.
- **formData**: (Optional) Form data including files as a `Map<String, dynamic>`.
- **curlOptions**: (Optional) Additional cURL options using the `CurlOptions` class.
- **maskSensitiveInfo**: (Optional) Whether to mask sensitive information like auth tokens.
- **formatOutput**: (Optional) Whether to format the output with line breaks for readability.

## Dependencies

- `dart:convert`
- `dart:io`
- `package:flutter/foundation.dart`

Ensure you have Flutter SDK installed and set up in your development environment.

## Troubleshooting

- **Issue**: `cURL` command not logging.
  - **Solution**: Ensure `showDebugPrint` is set to `true` or check your custom logger function.
  
- **Issue**: Malformed `cURL` command.
  - **Solution**: Verify the data format and parameter types passed to the method.

- **Issue**: Issues with file uploads.
  - **Solution**: Ensure the File object exists and has read permissions.
  
- **Issue**: Interceptors not working with HTTP clients.
  - **Solution**: Make sure you have the respective HTTP client packages installed and properly configured.

- **Issue**: ArgumentError is thrown.
  - **Solution**: Check the error message for details about the validation failure (empty method, invalid URL, etc.).

## Contributors

This package was authored by [Your Name/Team]. Contributions are welcome. Please submit issues and pull requests on the GitHub repository.

## License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for details.
