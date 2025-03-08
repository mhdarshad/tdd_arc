import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:tdd_arc/core/errors/erro_handler.dart';
import 'package:tdd_arc/core/errors/failures.dart';
import 'package:tdd_arc/tdd/data/datasource/local_data_source.dart';
import 'package:tdd_arc/tdd/domian/repositories/repository_provider.dart'
    show DependencyRepostProvider;
import 'package:tdd_arc/tdd_arc.dart' show GetRequest;
import '../../../core/util/network/network_info.dart';
import '../datasource/remote_data_sources.dart';
import '../model/repository_modle.dart';

class DataLayerRepositoryImpl implements DependencyRepostProvider<dynamic> {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  DataLayerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, dynamic>> getRequest(
    Request param, {
    bool isCached = true,
  }) => _getRequest(
    param.url.toString(),
    isCached,
    () => remoteDataSource.getRequest(param),
  );
  Future<Either<Failure, dynamic>> _getRequest(
    String key,
    bool isCached,
    GetRequest getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final RepositoryModel remoteTrivia = await getRequest();
        if (isCached) {
          localDataSource.saveData(key, remoteTrivia);
          print(remoteTrivia.data);
        }

        return Right(remoteTrivia.data);
      } on ServerExceptions catch (e) {
        print("ServerExceptions: ${e.toJson()}");
        if (isCached) {
          final RepositoryModel? localTrivia = await localDataSource.getData(
            key,
          );
          return Right(localTrivia?.data ?? {});
        } else {
          e.erroHandler();
          return Left(ServerFailure.fromJson(e.toJson()));
        }
      } on LocalDbExceptions catch (e) {
        print("LocalDbExceptions: ${e.toJson()}");
        final RepositoryModel? localTrivia = await localDataSource.getData(key);
        return Right(localTrivia?.data ?? {});
      }
    } else {
      try {
        if (isCached) {
          final RepositoryModel? localTrivia = await localDataSource.getData(
            key,
          );
          return Right(localTrivia?.data ?? {});
        } else {
          return Right({});
        }
      } on LocalDbExceptions catch (e) {
        print("LocalDbExceptions: ${e.toJson()}");
        return Left(DatabaseFailure.fromJson(e.toJson()));
      }
    }
  }
}
