# LogCurlRequest - Flutter Package

## Introduction

**LogCurlRequest** is a Flutter package designed to streamline the creation of `cURL` commands from your HTTP request details. This package provides developers with a simple and effective way to log HTTP requests as `cURL` commands, facilitating debugging and sharing of API calls.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Example](#example)
- [Configuration](#configuration)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
- [Contributors](#contributors)
- [License](#license)

## Features

- Generate `cURL` commands for HTTP requests.
- Supports adding HTTP headers, body data (JSON or plain text), and query parameters.
- Optionally logs the generated `cURL` command using Flutter's `debugPrint`.
- Easy to integrate with existing Flutter projects.

## Installation

To use this package, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  log_curl_request: ^0.0.3
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

Generate a `cURL` command:

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

Here’s an example of using the package to log a `cURL` command:

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

## Configuration

### Parameters

- **method**: The HTTP method (e.g., `GET`, `POST`).
- **path**: The API endpoint.
- **parameters**: (Optional) Query parameters as a `Map<String, dynamic>`.
- **data**: (Optional) The request body (supports `Map` or `String`).
- **headers**: (Optional) HTTP headers as a `Map<String, dynamic>`.
- **showDebugPrint**: (Optional) A boolean to enable logging of the generated `cURL` command.

## Dependencies

- `dart:convert`
- `package:flutter/foundation.dart`

Ensure you have Flutter SDK installed and set up in your development environment.

## Troubleshooting

- **Issue**: `cURL` command not logging.
  - **Solution**: Ensure `showDebugPrint` is set to `true`.
  
- **Issue**: Malformed `cURL` command.
  - **Solution**: Verify the data format and parameter types passed to the method.

## Contributors

This package was authored by [Your Name/Team]. Contributions are welcome. Please submit issues and pull requests on the GitHub repository.

## License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for details.
