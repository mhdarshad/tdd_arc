import 'package:internet_connection_checker/internet_connection_checker.dart' show InternetConnectionChecker,InternetConnectionStatus;
class DataConnectionChecker{
  DataConnectionChecker();
  Future<bool> get hasConnection async => await InternetConnectionChecker.instance.hasConnection;
  void listenConnection(Function(bool) hasConnection){
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      hasConnection(status == InternetConnectionStatus.connected);
    });
  }
}