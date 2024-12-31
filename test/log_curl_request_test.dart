import 'package:flutter_test/flutter_test.dart';

import 'package:log_curl_request/log_curl_request.dart';

void main() {
  test('create', () {
    final method = 'GET';
    final path = 'https://jsonplaceholder.typicode.com/posts';
    final parameters = {'userId': 1};
    final data = {'title': 'foo', 'body': 'bar', 'userId': 1};
    final headers = {'Content-Type': 'application/json'};
    final showDebugPrint = false;

    final result = LogCurlRequest.create(
      method,
      path,
      parameters: parameters,
      data: data,
      headers: headers,
      showDebugPrint: showDebugPrint,
    );

    final expected = 'curl -X $method -H "Content-Type: application/json" --data \'{"title":"foo","body":"bar","userId":1}\' "$path?userId=1"';
    expect(result, expected);
  });
}
