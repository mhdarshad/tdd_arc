import 'package:logger/logger.dart';

class ServerExceptions implements Exception{
  int code;
  String? messege;
  Object? error;

  ServerExceptions(this.code,[this.messege,this.error]);
  erroHandler(){
    Logger().e("ServerExceptions: $messege",time: DateTime.now(),error: error,stackTrace: StackTrace.current);
    if (code == 404) {
      return messege?? "Not Found";
    } else if (code == 401) {
      return messege??"Unauthorized";
    } else if (code == 500) {
      return messege??"Internal Server Error";
    } else {
      return messege??"Server Error";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'messege': messege,
    };
  }
}

class LocalDbExceptions implements Exception {
  final int code;
  final String? message;

  LocalDbExceptions(this.code, [this.message]);

  // Error handler method to return custom error messages based on the code
  String errorHandler() {
    Logger().e("ServerExceptions: $message",time: DateTime.now());

    if (code == 404) {
      return message ?? "Database not found";
    } else if (code == 401) {
      return message ?? "Unauthorized access to database";
    } else if (code == 500) {
      return message ?? "Database internal server error";
    } else {
      return message ?? "Unknown database error";
    }
  }

  // Convert the exception to a JSON-like map
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
