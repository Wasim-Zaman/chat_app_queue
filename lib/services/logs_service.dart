import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LogsService {
  static final LogsService _instance = LogsService._internal();
  factory LogsService() => _instance;
  LogsService._internal();

  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
    filter: DevelopmentFilter(),
    output: ConsoleOutput(),
  );

  void logRequest(
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

  void logResponse(http.Response response, Duration duration) {
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

  void logWarning(String message) {
    _logger.w(message);
  }

  void logError(String message) {
    _logger.e(message);
  }

  void logInfo(String message) {
    _logger.i(message);
  }
}
