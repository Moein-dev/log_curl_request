import 'package:flutter/material.dart';
import 'package:log_curl_request/log_curl_request.dart';

void main() {
  // Set up global configuration
  LogCurlConfig.instance.defaultFormatOutput = true;
  LogCurlConfig.instance.defaultCurlOptions = CurlOptions(
    compressed: true,
  );
  
  // Define a custom logger that both uses debugPrint and updates UI
  String latestLogMessage = '';
  LogCurlConfig.instance.loggerFunction = (message) {
    debugPrint(message);
    latestLogMessage = message;
  };
  
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
  int _selectedExampleIndex = 0;
  String _errorMessage = '';

  // List of example functions that generate different cURL commands
  final List<Map<String, dynamic>> _examples = [
    {
      'name': 'Basic POST Request',
      'function': () => LogCurlRequest.create(
        'POST',
        'https://api.example.com/data',
        headers: {'Content-Type': 'application/json'},
        data: {'name': 'Flutter', 'version': '3.0'},
        parameters: {'lang': 'dart'},
      ),
    },
    {
      'name': 'With Cookies',
      'function': () => LogCurlRequest.create(
        'GET',
        'https://api.example.com/profile',
        headers: {'Accept': 'application/json'},
        cookies: {'session': 'abc123', 'theme': 'dark'},
      ),
    },
    {
      'name': 'With cURL Options',
      'function': () => LogCurlRequest.create(
        'GET',
        'https://api.example.com/secure-endpoint',
        headers: {'Authorization': 'Bearer token12345'},
        curlOptions: CurlOptions(
          insecure: true,
          verbose: true,
          location: true,
          maxTime: 30,
          customOptions: ['--http2'],
        ),
      ),
    },
    {
      'name': 'Mask Sensitive Info',
      'function': () => LogCurlRequest.create(
        'GET',
        'https://api.example.com/user',
        headers: {
          'Authorization': 'Bearer very-secret-token',
          'x-api-key': 'secret-api-key',
          'User-Agent': 'MyApp/1.0',
        },
        maskSensitiveInfo: true,
      ),
    },
    {
      'name': 'Formatted Output',
      'function': () => LogCurlRequest.create(
        'POST',
        'https://api.example.com/complex-endpoint',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer token',
        },
        data: {
          'user': {'name': 'John', 'email': 'john@example.com'},
          'preferences': {'theme': 'dark', 'notifications': true},
        },
        formatOutput: true,
      ),
    },
    {
      'name': 'Form Data',
      'function': () => LogCurlRequest.create(
        'POST',
        'https://api.example.com/form',
        formData: {
          'name': 'John Doe',
          'email': 'john@example.com',
          'subscribe': 'true',
        },
      ),
    },
    {
      'name': 'Invalid URL (Error Handling)',
      'function': () => LogCurlRequest.create(
        'GET',
        'invalid-url',
      ),
    },
    {
      'name': 'Invalid Data Type (Error Handling)',
      'function': () => LogCurlRequest.create(
        'POST',
        'https://api.example.com/data',
        data: 123, // Invalid data type - should be Map or String
      ),
    },
    {
      'name': 'Using Global Config',
      'function': () {
        // This will use the global configuration set in main()
        // showing formatted output and --compressed by default
        return LogCurlRequest.create(
          'GET',
          'https://api.example.com/config-test',
          headers: {'User-Agent': 'ExampleApp/1.0'},
        );
      },
    },
    {
      'name': 'Override Global Config',
      'function': () {
        // This will override the global configuration
        return LogCurlRequest.create(
          'GET',
          'https://api.example.com/override-config',
          formatOutput: false, // Override global format setting
          curlOptions: CurlOptions(
            verbose: true,
          ), // Override global curl options
        );
      },
    },
  ];

  void _generateCurl() {
    // Get the selected example function
    try {
      final command = _examples[_selectedExampleIndex]['function']();
      
      setState(() {
        _curlCommand = command;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _curlCommand = '';
        _errorMessage = e.toString();
      });
      
      debugPrint('Error generating cURL command: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Example:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedExampleIndex,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedExampleIndex = newValue!;
                        });
                      },
                      items: List.generate(
                        _examples.length,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(_examples[index]['name']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _generateCurl,
                      child: const Text('Generate cURL'),
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_errorMessage),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Generated cURL Command:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _curlCommand.isEmpty
                        ? 'Select an example and press "Generate cURL" to see the result'
                        : _curlCommand,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}