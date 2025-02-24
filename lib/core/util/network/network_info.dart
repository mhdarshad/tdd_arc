// if (dart.library.html) "data_connection_checker_web.dart" as dc;


import 'data_connection_checker_web.dart'show DataConnectionChecker;

abstract class NetworkInfo{
  Future<bool> get isConnected; 
  void listenConnection(Function(bool) hasConnection);
}
class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
  
  @override
  void listenConnection(Function(bool isConnectd) hasConnection) => connectionChecker.listenConnection(hasConnection);

}