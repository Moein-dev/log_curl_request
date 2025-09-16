/// Class to define additional cURL options for the log_curl_request package.
/// 
/// This class provides various configuration options that can be applied
/// to cURL commands to modify their behavior, such as SSL verification,
/// compression, verbosity, and redirect handling.
class CurlOptions {
  /// Whether to use the --insecure option (skip SSL verification).
  /// 
  /// When set to true, cURL will not verify SSL certificates.
  /// This should only be used for testing purposes.
  final bool insecure;
  
  /// Whether to use the --compressed option.
  /// 
  /// When set to true, cURL will request compressed responses
  /// and automatically decompress them.
  final bool compressed;
  
  /// Whether to use the --verbose option.
  /// 
  /// When set to true, cURL will output detailed information
  /// about the request and response process.
  final bool verbose;
  
  /// Whether to use the --location option (follow redirects).
  /// 
  /// When set to true, cURL will automatically follow HTTP redirects.
  final bool location;
  
  /// Maximum time allowed for the transfer in seconds.
  /// 
  /// If set, adds the --max-time option to limit how long
  /// the transfer operation can take.
  final int? maxTime;
  
  /// Additional custom cURL options.
  /// 
  /// A list of custom command line options to include in the cURL command.
  /// Each option should be a complete flag (e.g., '--http2', '--connect-timeout 10').
  final List<String> customOptions;

  /// Creates a CurlOptions instance with the specified configuration.
  /// 
  /// All parameters are optional and have sensible defaults:
  /// - [insecure]: false (SSL verification enabled)
  /// - [compressed]: false (no compression requested)
  /// - [verbose]: false (quiet operation)
  /// - [location]: false (don't follow redirects)
  /// - [maxTime]: null (no time limit)
  /// - [customOptions]: empty list (no additional options)
  const CurlOptions({
    this.insecure = false,
    this.compressed = false,
    this.verbose = false,
    this.location = false,
    this.maxTime,
    this.customOptions = const [],
  });

  /// Creates a copy of this object with the given fields replaced with the new values.
  /// 
  /// This method allows you to create a modified version of the current
  /// CurlOptions while keeping unchanged values from the original instance.
  /// 
  /// Example:
  /// ```dart
  /// final options = CurlOptions(insecure: true);
  /// final newOptions = options.copyWith(verbose: true);
  /// // newOptions has both insecure: true and verbose: true
  /// ```
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
