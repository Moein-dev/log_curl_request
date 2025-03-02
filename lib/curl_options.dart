part of 'log_curl_request.dart';

/// Class to define additional cURL options.
class CurlOptions {
  /// Whether to use the --insecure option (skip SSL verification).
  final bool insecure;
  
  /// Whether to use the --compressed option.
  final bool compressed;
  
  /// Whether to use the --verbose option.
  final bool verbose;
  
  /// Whether to use the --location option (follow redirects).
  final bool location;
  
  /// Maximum time allowed for the transfer in seconds.
  final int? maxTime;
  
  /// Additional custom cURL options.
  final List<String> customOptions;

  /// Creates a CurlOptions instance.
  const CurlOptions({
    this.insecure = false,
    this.compressed = false,
    this.verbose = false,
    this.location = false,
    this.maxTime,
    this.customOptions = const [],
  });

  /// Creates a copy of this object with the given fields replaced with the new values.
  CurlOptions copyWith({
    bool? insecure,
    bool? compressed,
    bool? verbose,
    bool? location,
    int? maxTime,
    List<String>? customOptions,
  }) {
    return CurlOptions(
      insecure: insecure ?? this.insecure,
      compressed: compressed ?? this.compressed,
      verbose: verbose ?? this.verbose,
      location: location ?? this.location,
      maxTime: maxTime ?? this.maxTime,
      customOptions: customOptions ?? this.customOptions,
    );
  }
}
