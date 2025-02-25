
import 'package:dartz/dartz.dart';
import 'package:tdd_arc/core/errors/failures.dart';
import 'package:tdd_arc/tdd/data/datasource/remote_data_sources.dart';
import 'package:tdd_arc/tdd/domian/repositories/repository_provider.dart';
class UserDataUseCase extends UseCase<dynamic, dynamic>{
  const UserDataUseCase({required super.repo});
  @override
  Future<Either<Failure, dynamic>> call({required data}) async {
    var result = await repo.getRequest(Params(
        uri: Uri.parse('fetch-kyc'), methed: Methed.Post, data: data.toJson()));
    result.forEach((r) {
      print(r);
    });
    return result.fold((l) => Left(l), (r) =>  Right({}));
  }
}