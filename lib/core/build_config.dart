import 'package:flutter/material.dart';

abstract class BuildConfig {
  String get baseUrl;
  bool get isProd;
  // String get sslCert;
  Future<void> configure(Locale? locale);
//  Future<String> getPemCertForGCP();
//  FirebaseOptions getFirebaseConfig();
}
