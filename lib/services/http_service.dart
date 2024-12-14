import 'dart:convert';

import 'package:chat/config/app_config.dart';
import 'package:http/http.dart' as http;

enum HTTP_METHOD {
  get,
  post,
  put,
  delete,
}

class HttpService {
  String _baseUrl = AppConfig.baseUrl;

  HttpService();

  HttpService.baseUrl(String? baseUrl) {
    _baseUrl = baseUrl ?? _baseUrl;
  }

  Future<http.Response> _performRequest(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    HTTP_METHOD method = HTTP_METHOD.get,
  }) async {
    var uri = Uri.parse('$_baseUrl$url');
    try {
      http.Response response;
      switch (method) {
        case HTTP_METHOD.post:
          response =
              await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case HTTP_METHOD.put:
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case HTTP_METHOD.delete:
          response = await http.delete(uri, headers: headers);
          break;
        case HTTP_METHOD.get:
        default:
          response = await http.get(uri, headers: headers);
          break;
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> request(String endpoint,
      {dynamic data,
      HTTP_METHOD method = HTTP_METHOD.get,
      Map<String, String>? headers}) async {
    try {
      var response = await _performRequest(
        endpoint,
        headers: headers ?? {'Content-Type': 'application/json'},
        body: data,
        method: method,
      );
      return _processResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) async {
    try {
      final data = json.decode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          data['success'] == true) {
        return data;
      } else {
        String errorMessage = data['message'] ??
            data['error'] ??
            data['ERROR'] ??
            'Unknown error';

        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to process response: $e');
    }
  }
}
