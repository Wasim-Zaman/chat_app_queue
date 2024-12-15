import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

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

  void _logRequest(
    String method,
    String url,
    Map<String, String> headers,
    dynamic body,
  ) {
    final requestLog = StringBuffer();
    requestLog.writeln('\n🌐 REQUEST DETAILS');
    requestLog.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    requestLog.writeln('URL: $url');
    requestLog.writeln('METHOD: $method');
    requestLog.writeln(
        'HEADERS: ${const JsonEncoder.withIndent('  ').convert(headers)}');

    if (body != null) {
      final bodyStr = body is String
          ? body
          : const JsonEncoder.withIndent('  ').convert(body);
      requestLog.writeln('BODY: $bodyStr');
    }

    _logger.i(requestLog.toString());
  }

  void _logResponse(http.Response response, Duration duration) {
    final responseLog = StringBuffer();
    responseLog.writeln('\n📨 RESPONSE DETAILS [${duration.inMilliseconds}ms]');
    responseLog.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    responseLog.writeln('STATUS: ${response.statusCode}');
    responseLog.writeln('URL: ${response.request?.url}');

    if (response.headers.isNotEmpty) {
      responseLog.writeln(
          'HEADERS: ${const JsonEncoder.withIndent('  ').convert(response.headers)}');
    }

    if (response.body.isNotEmpty) {
      try {
        final dynamic jsonData = json.decode(response.body);
        final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
        responseLog.writeln('BODY: $prettyJson');
      } catch (e) {
        responseLog.writeln('BODY: ${response.body}');
      }
    }

    final icon =
        response.statusCode >= 200 && response.statusCode < 300 ? '✅' : '❌';
    _logger.i('$icon ${responseLog.toString()}');
  }

  // Main Request Method
  Future<dynamic> request(
    String endpoint, {
    HttpMethod method = HttpMethod.get,
    dynamic data,
    BuildContext? context,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _getHeaders();
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    final stopwatch = Stopwatch()..start();

    _logRequest(
      method.toString().split('.').last.toUpperCase(),
      '$_baseUrl$endpoint',
      headers,
      data,
    );

    var response = await _performRequest(
      endpoint,
      method,
      headers: headers,
      body: data,
    );

    stopwatch.stop();
    _logResponse(response, stopwatch.elapsed);

    // Handle Access Token Expiry
    if (response.statusCode == accessTokenExpiredCode) {
      _logger.w('🔄 Token expired, attempting refresh...');

      final refreshSuccess = await _refreshTokens();
      if (refreshSuccess) {
        _logger.i('🔑 Token refresh successful, retrying request...');

        final newHeaders = await _getHeaders();
        response = await _performRequest(
          endpoint,
          method,
          headers: newHeaders,
          body: data,
        );

        _logResponse(response, stopwatch.elapsed);
      } else if (context != null && context.mounted) {
        _logger.e('❌ Token refresh failed');
        _handleUnauthorized(context);
        throw Exception('Session expired. Please login again.');
      }
    }

    // Handle Refresh Token Expiry
    if (response.statusCode == refreshTokenExpiredCode &&
        context != null &&
        context.mounted) {
      _logger.e('🚫 Refresh token expired');
      _handleUnauthorized(context);
      throw Exception('Session expired. Please login again.');
    }

    return _processResponse(response);
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
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw HttpException(
        data['message'] ?? 'Something went wrong',
        code: response.statusCode,
      );
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
