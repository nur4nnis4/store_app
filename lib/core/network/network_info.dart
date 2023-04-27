import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo({required this.connectivity});

  // @override
  // Stream<bool> get isConnected => connectivity.onConnectivityChanged
  //     .map((event) => event != ConnectivityResult.none);

  Future<bool> get isConnected => connectivity
      .checkConnectivity()
      .then((event) => event != ConnectivityResult.none);
}
