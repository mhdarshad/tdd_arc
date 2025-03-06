import 'package:logger/logger.dart';

abstract class Failure {
  String messege;
  Failure({required this.messege});
  errorHandling();
}

class ServerFailure extends Failure {
  int code;

  ServerFailure({required this.code, required super.messege});

  @override
  errorHandling() {
    // Log the error when handling the server failure message
    Logger().e("ServerFailure: $messege", time: DateTime.now());
    return "Server Error: $messege";
  }

  // From JSON method for parsing error details from a response
  ServerFailure.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        super(messege: json['messege']) {
    // Log the error when receiving the JSON data
    Logger().e("Received error response: ${json['messege']}: ${json['error']}", time: DateTime.now());
  }
}
class DatabaseFailure extends Failure {
  int code;

  DatabaseFailure({required this.code, required super.messege});

  @override
  errorHandling() {
    // Log the database error with the timestamp
    Logger().e("DatabaseFailure: $messege", time: DateTime.now());
    return "Database Error: $messege";
  }

  // From JSON method for parsing database error details from a response
  DatabaseFailure.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        super(messege: json['messege']) {
    // Log the error when receiving the JSON data for database failure
    Logger().e("Received database error response: ${json['messege']}", time: DateTime.now());
  }
}
