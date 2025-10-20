import 'package:get_it/get_it.dart';

abstract class IConnectionService implements Disposable {
  const IConnectionService();

  Stream<bool> get connection;

  Future<bool> hasConnection();

  Future<bool> manualConnectionCheck();
  bool lastConnectionResult();
}
