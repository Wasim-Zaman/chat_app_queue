import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../screens/auth/signin_screen.dart';
import '../utils/navigation_util.dart';
import 'storage_service.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class HttpService {
  // Status codes for token expiry
  static const int accessTokenExpiredCode = 401;
  static const int refreshTokenExpiredCode = 403;

  final String _baseUrl;
  bool _isRefreshing = false;
  final StorageService _storage = StorageService();

  HttpService({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.baseUrl;

  // Headers with Authorization
  Future<Map<String, String>> _getHeaders() async {
    final accessToken = await _storage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  // Refresh Token Logic
  Future<bool> _refreshTokens() async {
    if (_isRefreshing) return false;

    try {
      _isRefreshing = true;
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken == null) {
        return false;
      }

      // TODO: Replace with your refresh token endpoint
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // Handle Unauthorized Access
  void _handleUnauthorized(BuildContext context) async {
    await _storage.clearTokens();
    if (context.mounted) {
      NavigationUtil.navigateTo(
        context,
        const SignInScreen(),
        clearStack: true,
      );
    }
  }

  // Main Request Method
  Future<dynamic> request(
    String endpoint,
    HttpMethod method, {
    dynamic data,
    BuildContext? context,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final headers = await _getHeaders();
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }

      var response = await _performRequest(
        endpoint,
        method,
        headers: headers,
        body: data,
      );

      // Handle Access Token Expiry
      if (response.statusCode == accessTokenExpiredCode) {
        final refreshSuccess = await _refreshTokens();
        if (refreshSuccess) {
          // Retry the original request with new token
          final newHeaders = await _getHeaders();
          response = await _performRequest(
            endpoint,
            method,
            headers: newHeaders,
            body: data,
          );
        } else if (context != null && context.mounted) {
          _handleUnauthorized(context);
          throw Exception('Session expired. Please login again.');
        }
      }

      // Handle Refresh Token Expiry
      if (response.statusCode == refreshTokenExpiredCode &&
          context != null &&
          context.mounted) {
        _handleUnauthorized(context);
        throw Exception('Session expired. Please login again.');
      }

      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Perform HTTP Request
  Future<http.Response> _performRequest(
    String endpoint,
    HttpMethod method, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final jsonBody = body != null ? jsonEncode(body) : null;

    switch (method) {
      case HttpMethod.get:
        return await http.get(uri, headers: headers);
      case HttpMethod.post:
        return await http.post(uri, headers: headers, body: jsonBody);
      case HttpMethod.put:
        return await http.put(uri, headers: headers, body: jsonBody);
      case HttpMethod.delete:
        return await http.delete(uri, headers: headers);
    }
  }

  // Process Response
  dynamic _processResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw HttpException(
          data['message'] ?? 'Something went wrong',
          code: response.statusCode,
        );
      }
    } catch (e) {
      throw Exception('Failed to process response: $e');
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int code;

  HttpException(this.message, {required this.code});

  @override
  String toString() => 'HttpException: $message (Code: $code)';
}
