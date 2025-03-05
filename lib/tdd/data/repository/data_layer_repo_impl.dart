

import 'package:dartz/dartz.dart';
import 'package:tdd_arc/core/errors/erro_handler.dart';
import 'package:tdd_arc/core/errors/failures.dart';
import 'package:tdd_arc/tdd/domian/repositories/repository_provider.dart' show DependencyRepostProvider;
import 'package:tdd_arc/tdd_arc.dart' show GetRequest;
import '../../../core/util/network/network_info.dart';
import '../datasource/remote_data_sources.dart';
import '../model/repository_modle.dart';

class DataLayerRepositoryImpl implements DependencyRepostProvider<dynamic>{
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  DataLayerRepositoryImpl({required this.remoteDataSource, required this. networkInfo});

  @override
  Future<Either<Failure, dynamic>> getRequest(dynamic param) =>_getRequest(param.uri.toString(),() => remoteDataSource.getRequest(param));
  Future<Either<Failure, dynamic>> _getRequest(String key,GetRequest getRequest) async{
    if (await networkInfo.isConnected) {
      try {
        final RepositoryModel remoteTrivia = await getRequest();
        print(remoteTrivia.data);
        return Right(remoteTrivia.data);
      } on ServerExceptions catch(e){
        e.erroHandler();
        return Left(ServerFailure.fromJson(e.toJson()));
      }
    } else {
      try {
        return Right({});
      } on LocalDbExceptions catch(e){
        print("LocalDbExceptions: ${e.toJson()}");
        return Left(DatabaseFailure.fromJson(e.toJson()));
      }
    }
  }
}