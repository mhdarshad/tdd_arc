import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_arc/core/errors/erro_handler.dart';
import 'package:tdd_arc/core/util/extension/validations.dart';
import '../model/repository_modle.dart';
import 'package:equatable/equatable.dart';

enum Methed { Get, Post, Put, Delete }

// ignore: must_be_immutable
abstract class Request extends http.Request implements Equatable {
  Request(Methed method, Uri url, Map<String, String> bodyFields)
    : super(method.name, url,) {
    this.bodyFields = bodyFields;
  }
  @override
  List<Object?> get props => [method, url, bodyFields];
}

abstract class RemoteDataSource {
  Future<RepositoryModel> getRequest(Request param);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseurl;
  String? _bearerToken;

  RemoteDataSourceImpl({required this.client, required this.baseurl});

  @override
  Future<RepositoryModel> getRequest(Request param) => _fetchData(param);

  Future<RepositoryModel> _fetchData(Request param) async {
    try {
      debugPrint("Starting request...");

      final queryString =
          param.method == Methed.Get ? _buildQueryString(param.bodyFields) : '';
      final uri = Uri.parse('$baseurl${param.url}$queryString');

      final request = _createRequest(param, uri.fixUrl);
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
    return '?${data.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  http.Request _createRequest(Request param, Uri uri) {
    final request = http.Request(param.method, uri);
    request.headers.addAll(_getRequestHeaders());

    if (param.method == Methed.Post || param.method == Methed.Put) {
      print(json.encode(_mapRequestData(param)));
      request.body = json.encode(_mapRequestData(param));
    }

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

  Map<String, String> _mapRequestData(Request param) {
    return param.bodyFields.map(
          (key, value) => MapEntry(key, value.toString()),
        );
  }

  Future<http.StreamedResponse> _sendRequest(http.Request request) async {
    debugPrint("Sending ${request.method} request to ${request.url} params: ${request.body}");
    return await request.send();
  }

  Future<RepositoryModel> _processResponse(
    http.StreamedResponse response,
  ) async {
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
    final errorJson = json.decode(responseBody);

    try {
      return errorJson['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Unknown error occurred : $e';
    }
  }
}
