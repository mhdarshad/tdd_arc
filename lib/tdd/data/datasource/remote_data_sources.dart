import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_arc/core/errors/erro_handler.dart';
import 'package:tdd_arc/core/util/extension/validations.dart';
import '../model/repository_modle.dart';
import 'package:equatable/equatable.dart';

enum Methed { Get, Post, Put, Delete }

// Define a request model instead of extending `http.Request`
class ApiRequest extends Equatable {
  final Methed method;
  final String endpoint;
  final Map<String, dynamic>? body;

  ApiRequest({
    required this.method,
    required this.endpoint,
    this.body,
  });

  @override
  List<Object?> get props => [method, endpoint, body];
}

abstract class RemoteDataSource {
  Future<RepositoryModel> getRequest(ApiRequest param);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseurl;
  String? _bearerToken;

  RemoteDataSourceImpl({required this.client, required this.baseurl});

  @override
  Future<RepositoryModel> getRequest(ApiRequest param) async {
    final result = await _fetchData(param);
    if (result == null) {
      throw ServerExceptions(500, 'Failed to fetch data');
    }
    return result;
  }

  Future<RepositoryModel> _fetchData(ApiRequest param) async {
    try {
      debugPrint("Starting request...");

      final queryString =
          param.method == Methed.Get ? _buildQueryString(param.body) : '';
      final uri = Uri.parse('$baseurl${param.endpoint}$queryString');

      final request = _createRequest(param, uri);
      final response = await _sendRequest(request);

      return _processResponse(response);
    } catch (e) {
      throw ServerExceptions(
        500,
        'An error occurred while processing your request',
        e,
      );
    }
  }

  String _buildQueryString(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return '';
    return '?${data.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}').join('&')}';
  }

  http.Request _createRequest(ApiRequest param, Uri uri) {
    final request = http.Request(param.method.name.toUpperCase(), uri);
    request.headers.addAll(_getRequestHeaders());

    if (param.method == Methed.Post || param.method == Methed.Put) {
      request.body = json.encode(param.body);
    }
    
    debugPrint("Request body: ${request.body}");
    return request;
  }

  Map<String, String> _getRequestHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }

    return headers;
  }

  Future<http.StreamedResponse> _sendRequest(http.Request request) async {
    debugPrint("Sending ${request.method} request to ${request.url} with body: ${request.body}");
    return await client.send(request);
  }

  Future<RepositoryModel> _processResponse(http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();
    debugPrint("Response status: ${response.statusCode}, Body: $responseBody");

    if (response.statusCode == 200) {
      return RepositoryModel.fromJson(json.decode(responseBody));
    } else {
      final errorMessage = _extractErrorMessage(responseBody);
      throw ServerExceptions(response.statusCode, errorMessage);
    }
  }

  String _extractErrorMessage(String responseBody) {
    try {
      final errorJson = json.decode(responseBody);
      return errorJson['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Unknown error occurred : $e';
    }
  }
}
