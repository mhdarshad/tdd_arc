import 'package:dartz/dartz.dart' show Either;
import 'package:tdd_arc/core/errors/failures.dart' show Failure;
import 'package:tdd_arc/tdd/data/model/repository_modle.dart' show RepositoryModel;
import 'package:velocity_x/velocity_x.dart' show VxState, VxStatus;

typedef VelocityState = VxState;
typedef VelocityStatus = VxStatus;
typedef GetRequest = Future<RepositoryModel> Function();
typedef EitherOrFailure<T> = Either<Failure, T>;
 
/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
