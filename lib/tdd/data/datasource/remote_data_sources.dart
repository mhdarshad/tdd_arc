import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_arc/core/errors/erro_handler.dart';
import 'package:tdd_arc/core/util/store/store.dart';
import '../model/repository_modle.dart';
import 'package:equatable/equatable.dart';

enum Methed { Get, Post, Put, Delete }

// Define a request model instead of extending `http.Request`
class ApiRequest extends Equatable {
  final Methed method;
  final String endpoint;
  final Map<String, dynamic>? body;

  const ApiRequest({required this.method, required this.endpoint, this.body});

  @override
  List<Object?> get props => [method, endpoint, body];
}

abstract class RemoteDataSource {
  Future<RepositoryModel> getRequest(http.Request param);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseurl;
  String? _bearerToken;
  String? _barterToken;

  RemoteDataSourceImpl({required this.client, required this.baseurl});

  @override
  Future<RepositoryModel> getRequest(http.Request param) async {
    final result = await _fetchData(param);
    return result;
  }

  Future<RepositoryModel> _fetchData(http.Request param) async {
    try {
      debugPrint("Starting request...");

      final queryString =
          param.method == Methed.Get.name
              ? _buildQueryString(param.bodyFields)
              : '';
      final uri = Uri.parse('$baseurl${param.url}$queryString');

      final request = _createRequest(param, uri);
      final response = await _sendRequest(request);

      return _processResponse(response);
    } catch (e) {
      debugPrint(e.toString());
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

  http.Request _createRequest(http.Request param, Uri uri) {
    final request = http.Request(param.method.toUpperCase(), uri);
    request.headers.addAll(_getRequestHeaders());

    if (param.method == Methed.Post.name || param.method == Methed.Put.name) {
      request.body = json.encode(param.bodyFields);
      debugPrint("Request body: ${request.body}");
    }

    return request;
  }

  Map<String, String> _getRequestHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _bearerToken = ProjectStore.stored.token;
    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }

    if (_barterToken != null) {
      headers['Barter-Authorization'] = 'Barter $_barterToken';
    }

    return headers;
  }

  Future<http.StreamedResponse> _sendRequest(http.Request request) async {
    debugPrint(
      "Sending ${request.method} request to ${request.url} with body: ${request.body}",
    );
    return await client.send(request);
  }

  Future<RepositoryModel> _processResponse(
    http.StreamedResponse response,
  ) async {
    final responseBody = await response.stream.bytesToString();
    debugPrint("Response status: ${response.statusCode}, Body: $responseBody");

    if (response.statusCode == 200 || response.statusCode == 201) {
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
