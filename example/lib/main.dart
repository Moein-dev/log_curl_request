import 'package:flutter/material.dart';
import 'package:log_curl_request/log_curl_request.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cURL Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'cURL Generator Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _curlCommand = '';

  void _generateCurl() {
    // Create a cURL command for a POST request
    final command = LogCurlRequest.create(
      'POST',
      'https://api.example.com/data',
      headers: {'Content-Type': 'application/json'},
      data: {'name': 'Flutter', 'version': '3.0'},
      parameters: {'lang': 'dart'},
    );

    setState(() {
      _curlCommand = command;
    });

    debugPrint(_curlCommand); // Print the cURL command to the debug console
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Generated cURL Command:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _curlCommand.isEmpty ? 'Press the button to generate' : _curlCommand,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateCurl,
        tooltip: 'Generate cURL',
        child: const Icon(Icons.code),
      ),
    );
  }
}