import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/subjects.dart';
import 'package:ryal_mobile/services/i_connection_service.dart';

@LazySingleton(as: IConnectionService)
class ConnectionServiceImpl extends IConnectionService {
  ConnectionServiceImpl() {
    // Initialize with optimistic connection status
    _connectivityStream.add(true);
    _initializeConnectivityListener();
  }

  final _connectivityStream = BehaviorSubject<bool>.seeded(true);
  late final StreamSubscription<List<ConnectivityResult>> _connectivity;
  StreamSubscription<InternetConnectionStatus>? _socketConnectivityChecker;
  
  // Configure InternetConnectionChecker with faster check times and reliable hosts
  final _internetChecker = InternetConnectionChecker.createInstance(
    checkInterval: const Duration(seconds: 3),
    checkTimeout: const Duration(seconds: 3),
    addresses: [
      AddressCheckOption(
        uri: Uri.parse('https://8.8.8.8'),  // Google DNS
        timeout: const Duration(seconds: 2),
      ),
      AddressCheckOption(
        uri: Uri.parse('https://1.1.1.1'),  // Cloudflare DNS
        timeout: const Duration(seconds: 2),
      ),
      AddressCheckOption(
        uri: Uri.parse('https://dns.google'),  // Google DNS over HTTPS
        timeout: const Duration(seconds: 2),
      ),
    ],
  );

  /// Listens for changes to the device's connectivity status and updates the
  /// connection stream when a change is detected.
  ///
  /// This method is used internally to update the connection stream with the
  /// current connectivity status. It will cancel any existing subscription and
  /// set up a new one.
  ///
  /// This method is used during object initialization.
  void _initializeConnectivityListener() {
    _connectivity = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) => _checkConnectivity(results),
    );
  }

  @override
  Stream<bool> get connection => _connectivityStream.stream.distinct();

  @override
  /// Checks if the device has a connection to the internet.
  ///
  /// This method performs a quick connectivity check first. If the device has no
  /// connectivity, it will return false immediately. Otherwise, it will check for
  /// a WiFi or mobile connection and then use the [InternetConnectionChecker] to
  /// verify the connection. If the checker fails, it will assume the device has a
  /// connection and set up monitoring. If the checker succeeds, it will set up
  /// monitoring and return the result of the check.
  ///
  /// If the device has some kind of connection, but not a WiFi or mobile
  /// connection, it will default to true.
  Future<bool> hasConnection() async {
    // Quick connectivity check first
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    
    // Early return if no connectivity
    if (results.contains(ConnectivityResult.none)) {
      _updateConnectivity(false);
      return false;
    }

    // Check for WiFi or mobile connection
    if (results.any((result) => 
        result == ConnectivityResult.wifi || 
        result == ConnectivityResult.mobile)) {
      
      try {
        final hasConnection = await _internetChecker.hasConnection;
        _updateConnectivity(hasConnection);
        
        if (hasConnection) {
          _setupSocketChecker();
        }
        
        return hasConnection;
      } catch (e) {
        // Assume connection on check failure and set up monitoring
        _updateConnectivity(true);
        _setupSocketChecker();
        return true;
      }
    }

    // Default to true if we have some kind of connection
    _updateConnectivity(true);
    return true;
  }

  /// Checks the current connectivity status and updates the connection stream.
  ///
  /// This method is used internally to update the connection stream with the
  /// current connectivity status. It will cancel any existing subscription and
  /// set up a new one.
  ///
  /// This method is used after a connectivity change event is detected.
  ///
  /// Returns `true` if the device has an active internet connection, or `false`
  /// otherwise.
  Future<bool> _checkConnectivity(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      _updateConnectivity(false);
      await _socketConnectivityChecker?.cancel();
      _socketConnectivityChecker = null;
      return false;
    }

    if (results.any((result) => 
        result == ConnectivityResult.wifi || 
        result == ConnectivityResult.mobile)) {
      try {
        final hasConnection = await _internetChecker.hasConnection;
        _updateConnectivity(hasConnection);
        await _setupSocketChecker();
        return hasConnection;
      } catch (e) {
        return _connectivityStream.value;
      }
    }

    return _connectivityStream.value;
  }

  /// Sets up a stream subscription to listen for changes to the device's
  /// internet connection status.
  ///
  /// This method is used internally to update the connection stream with the
  /// current connectivity status. It will cancel any existing subscription and
  /// set up a new one.
  ///
  /// This method is used after a connectivity change event is detected.
  Future<void> _setupSocketChecker() async {
    await _socketConnectivityChecker?.cancel();

    _socketConnectivityChecker = _internetChecker.onStatusChange.listen(
      (status) => _updateConnectivity(status == InternetConnectionStatus.connected),
    );
  }

  /// Updates the connection stream with the current connectivity status.
  ///
  /// This method is used internally to update the connection stream with the
  /// current connectivity status. It will not update the stream if it is closed.
  ///
  /// [isConnected] - true if the device has a connection, false otherwise.
  void _updateConnectivity(bool isConnected) {
    if (!_connectivityStream.isClosed) {
      _connectivityStream.add(isConnected);
    }
  }

  @override
  /// Manually checks the connection status and updates the connection stream.
  ///
  /// This method is used to trigger a manual connectivity check when the app
  /// is started or resumed. It will update the connection stream with the
  /// current connectivity status.
  ///
  /// Returns true if the device has a connection, false otherwise.
  Future<bool> manualConnectionCheck() async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();

    if (results.contains(ConnectivityResult.none)) {
      _updateConnectivity(false);
      return false;
    }

    if (results.any((result) => 
        result == ConnectivityResult.wifi || 
        result == ConnectivityResult.mobile)) {
      final hasConnection = await _internetChecker.hasConnection;
      _updateConnectivity(hasConnection);
      return hasConnection;
    }

    return _connectivityStream.value;
  }

  @override
  bool lastConnectionResult() {
    return _connectivityStream.value;
  }

  @override
  Future<void> onDispose() async {
    await _socketConnectivityChecker?.cancel();
    await _connectivity.cancel();
    await _connectivityStream.close();
  }
}