import 'package:dartz/dartz.dart';
import 'package:tdd_arc/core/errors/failures.dart';

// Assuming UseCase looks like this, with a generic signature.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call({required Params data});
}

abstract class LogicHandler<T,Params> {
  final Set<UseCase<dynamic, Params>> usecases;

  LogicHandler(this.usecases);

  // Refactor to find the specific usecase by its type
  UC usecase<UC>() {
    return usecases.firstWhere(
      (element) => element is UC,
      orElse: () => throw Exception('UseCase of type $T not found'),
    ) as UC;
  }

  T call({required Params data});
}

/*

class GetUserController extends LogicHandler<GetUserEvents,dynamic> {
  GetUserController(super.usecases);

  @override
  call({required dynamic data}) => GetUserEvents(UserDataEvents.logIn, call: (store, onError, onSuccess) async {
        final request = await usecase<UserDataUseCase>()(data: data);
        request.fold(
          (l) => onError(message: l.messege),
          (r) => onSuccess(data: r, status: AppState.success),
        );
      });
}

class GetUserEvents extends EventMutations<UserDataEvents> {
  GetUserEvents(super.event, {required super.call});
  @override
  onError({String? message, String? type}) {
    print("Error: $message");
    errorToast(message ?? "Some thing went Wrong");
  }

  @override
  void onSuccess({required Map<String, dynamic> data, AppState? status}) {
    // TODO: implement onSuccess
  }
}
enum UserDataEvents {
  logIn,
}
*/