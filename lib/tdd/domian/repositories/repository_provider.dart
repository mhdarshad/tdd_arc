import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:tdd_arc/core/errors/failures.dart';
import 'package:tdd_arc/tdd/data/datasource/remote_data_sources.dart';

abstract class DependencyRepostProvider<Entities> {
  Future<Either<Failure, Entities>> getRequest(Request param);
}

abstract class UseCase<Return, Params> {
  const UseCase({required this.repo});
  final DependencyRepostProvider repo;
  Future<Either<Failure, Return>> call({required Params data});
  response<R>(R r) => Right(r);
}

 

abstract class UseCaseNoParams<Return> {
  Future<Either<Failure, Return>> call();
}

abstract class UseCaseNoReturn<Params> {
  Future<Either<Failure, void>> call({required Params data});
}

abstract class UseCaseNoReturnNoParams {
  Future<Either<Failure, void>> call();
}

class Params extends Request {
  final Uri uri;
  final Methed methed;
  final Map<String, dynamic> data;
  Params({required this.uri, required this.methed, required this.data}) : super(methed.name, uri){
    super.bodyFields = map(data);
  }
}
  Map<String, String> map(Map<String, dynamic> data) => data.map((key, value) => MapEntry(key, value.toString()));
