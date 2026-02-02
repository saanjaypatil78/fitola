import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fitola/config/constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();
  
  final _client = http.Client();
  String? _authToken;
  
  // Configuration
  static const int maxRetries = 3;
  static const Duration timeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  void clearAuthToken() {
    _authToken = null;
  }
  
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }
  
  Future<Map<String, dynamic>> get(String endpoint, {int retryCount = 0}) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .get(url, headers: _headers)
          .timeout(timeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      return _handleRetry(() => get(endpoint, retryCount: retryCount + 1), retryCount);
    } on SocketException {
      return _handleRetry(() => get(endpoint, retryCount: retryCount + 1), retryCount);
    } catch (e) {
      throw ApiException('Network error: $e', type: ApiErrorType.network);
    }
  }
  
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
    {int retryCount = 0}
  ) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .post(
            url,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      return _handleRetry(() => post(endpoint, body, retryCount: retryCount + 1), retryCount);
    } on SocketException {
      return _handleRetry(() => post(endpoint, body, retryCount: retryCount + 1), retryCount);
    } catch (e) {
      throw ApiException('Network error: $e', type: ApiErrorType.network);
    }
  }
  
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
    {int retryCount = 0}
  ) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .put(
            url,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      return _handleRetry(() => put(endpoint, body, retryCount: retryCount + 1), retryCount);
    } on SocketException {
      return _handleRetry(() => put(endpoint, body, retryCount: retryCount + 1), retryCount);
    } catch (e) {
      throw ApiException('Network error: $e', type: ApiErrorType.network);
    }
  }
  
  Future<Map<String, dynamic>> delete(String endpoint, {int retryCount = 0}) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .delete(url, headers: _headers)
          .timeout(timeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      return _handleRetry(() => delete(endpoint, retryCount: retryCount + 1), retryCount);
    } on SocketException {
      return _handleRetry(() => delete(endpoint, retryCount: retryCount + 1), retryCount);
    } catch (e) {
      throw ApiException('Network error: $e', type: ApiErrorType.network);
    }
  }
  
  Future<Map<String, dynamic>> _handleRetry(
    Future<Map<String, dynamic>> Function() request,
    int retryCount,
  ) async {
    if (retryCount >= maxRetries) {
      throw ApiException(
        'Request failed after $maxRetries retries',
        type: ApiErrorType.timeout,
      );
    }
    
    await Future.delayed(retryDelay * (retryCount + 1));
    return request();
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final error = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {'detail': 'Unknown error'};
      
      final errorMessage = error['detail'] ?? 
          error['message'] ?? 
          'Request failed with status ${response.statusCode}';
      
      // Determine error type based on status code
      ApiErrorType errorType;
      if (response.statusCode == 401) {
        errorType = ApiErrorType.unauthorized;
      } else if (response.statusCode == 403) {
        errorType = ApiErrorType.forbidden;
      } else if (response.statusCode == 404) {
        errorType = ApiErrorType.notFound;
      } else if (response.statusCode >= 500) {
        errorType = ApiErrorType.server;
      } else {
        errorType = ApiErrorType.unknown;
      }
      
      throw ApiException(errorMessage, type: errorType, statusCode: response.statusCode);
    }
  }
}

enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  server,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final int? statusCode;
  
  ApiException(
    this.message, {
    this.type = ApiErrorType.unknown,
    this.statusCode,
  });
  
  @override
  String toString() => message;
  
  bool get isNetworkError => type == ApiErrorType.network || type == ApiErrorType.timeout;
  bool get isAuthError => type == ApiErrorType.unauthorized || type == ApiErrorType.forbidden;
  bool get isServerError => type == ApiErrorType.server;
}
