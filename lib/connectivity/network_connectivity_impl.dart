import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:connection_checker/connection_checker.dart';

class NetworkConnectivityImpl implements NetworkConnectivity {
  final _checker = ConnectionChecker();

  @override
  Future<bool> checkNetworkConnection() async {
    return await _checker.checkConnection();
  }
}