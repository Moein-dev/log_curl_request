# Changelog

## 0.0.5

- **Fixed**:
- Resolved an error where non-string parameter values caused URL formatting issues.  
- Fixed data formatting for `Map` types in the `--data` section to prevent JSON encoding failures.  

- **Improved**:
- Optimized `queryString` generation logic for URL parameters.  
- Added basic validation for `method` and `path` to ensure they are non-empty.  

- **Documentation**:
- Updated `README.md` with clearer usage examples.  
- Enhanced Dartdoc comments for the `create` method parameters to improve API clarity.  

---

## 0.0.4

- **Fixed**:
- Fixed a bug where parameters were not correctly appended to the URL.  

---

## 0.0.3

- **Documentation**:
- Fixed typos and formatting issues in the `README.md` file.  

---

## 0.0.2

- **Improved**:
- Enhanced logging format for better readability.  
- Updated dependencies to their latest stable versions.  

- **Fixed**:
- Addressed an issue where some requests were not logged properly.  

---

## 0.0.1

- Initial release of the `log_curl_request` package.
