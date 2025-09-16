# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2024-09-16

### Fixed
- **Library Structure**: Removed problematic `part` declarations and converted to proper library structure with exports
- **API Documentation**: Added comprehensive documentation for all public members to comply with `public_member_api_docs` lint rule
- **Security**: Added shell escaping for header values, cookie values, and file paths to prevent command injection
- **Error Handling**: Enhanced error handling in interceptor methods with better validation and fallbacks
- **Boolean Logic**: Fixed CurlOptions merging logic to use proper `copyWith` method

### Added
- Shell escaping utility for safer cURL command generation
- Comprehensive API documentation with examples
- Better error messages and warnings in interceptor methods
- Test coverage for shell escaping and form data handling

### Changed
- Consolidated interceptor functionality into main library file to avoid circular imports
- Improved parameter validation with more descriptive error messages
- Enhanced interceptor methods with defensive programming practices

## [0.1.0] - Previous Release

### New Features
- Added support for file uploads via multipart form data
- Added cookie handling with the `cookies` parameter
- Added additional cURL options via the `CurlOptions` class
- Added option to mask sensitive information like auth tokens with `maskSensitiveInfo`
- Added formatted output option with line breaks for better readability
- Added integrations with popular HTTP client libraries (Dio, http)
- Added global configuration system with `LogCurlConfig` class
- Added custom logging functionality with `loggerFunction`
- Added robust input validation and error handling
- Added `copyWith` method to `CurlOptions` for easier modification

### Improvements
- Improved code documentation and API reference
- Enhanced test coverage with more test cases
- Updated example app with showcase of all features including error handling
- Added error display in example app
- Relaxed SDK constraints to support more Flutter versions (>=3.0.0)
- Improved formatting of generated cURL commands
- Added parameter validation to prevent runtime errors
- Improved interceptors for real HTTP client integration

## 0.0.5

- Updated minimum Flutter SDK version to 3.6.0.
- Updated Flutter Lints to 5.0.0.
- Added platforms field to pubspec.yaml.

## 0.0.4

- Updated minimum Flutter SDK version to 3.0.0.
- Updated Flutter Lints to 3.0.0.
- Update project to handle newer Flutter requirements.

## 0.0.3

- Support for pubspec.yaml platforms.

## 0.0.2

- Added more comprehensive documentation.
- Added an example project.
- Improved README with usage examples.

## 0.0.1

- Initial release with basic cURL command generation functionality.
- Support for HTTP methods, headers, query parameters, and data.
