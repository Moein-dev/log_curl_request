# log_curl_request

A Dart package to log HTTP requests in cURL format. This is useful for debugging and sharing request details.

## Features

- Log HTTP requests in cURL format.
- Supports various HTTP methods.
- Easy integration with existing Dart/Flutter projects.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
    log_curl_request: ^1.0.0
```

Then run:

```sh
flutter pub get
```

## Getting started

To start using the package, import it into your Dart code:

```dart
import 'package:log_curl_request/log_curl_request.dart';
```

## Usage

Here's a simple example of how to use the `log_curl_request` package:

```dart
import 'package:log_curl_request/log_curl_request.dart';

void main() {
    final logger = CurlLogger();
    logger.log('https://api.example.com/data', method: 'GET');
}
```

## Additional information

For more information, visit the [package page on pub.dev](https://pub.dev/packages/log_curl_request).

For information about how to write a good package README, see the guide for [writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for [creating packages](https://dart.dev/guides/libraries/create-packages) and the Flutter guide for [developing packages and plugins](https://flutter.dev/to/develop-packages).
