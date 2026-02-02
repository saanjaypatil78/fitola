import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitola/config/constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();
  
  final _client = http.Client();
  String? _authToken;
  
  // Request timeout configuration
  static const Duration _requestTimeout = Duration(seconds: 30);
  
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
  
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .get(url, headers: _headers)
          .timeout(_requestTimeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .post(
            url,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .put(
            url,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client
          .delete(url, headers: _headers)
          .timeout(_requestTimeout);
      
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
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
      throw ApiException(
        error['detail'] ?? 'Request failed with status ${response.statusCode}',
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}
