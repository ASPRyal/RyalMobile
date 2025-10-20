import 'package:flutter/material.dart';
import 'package:ryal_mobile/core/build_config.dart';
import 'package:ryal_mobile/main.dart';

//@Injectable(as: BuildConfig, env: [Environment.dev])
class BuildConfigDev extends BuildConfig {
  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyCgYNNLII_ixeBt-jV7vtDkpIIXFkXWQv4',
  //   appId: '1:907109666605:android:2c82699a5e733ba4d84da4',
  //   messagingSenderId: '907109666605',
  //   projectId: 'karty-host-dev-qa-02',
  //   storageBucket: 'karty-host-dev-qa-02.appspot.com',
  // );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyCwpVWfPFGW55iA0NgQlXTr9ffiSVAgSBY',
  //   appId: '1:907109666605:ios:49456d5f13ccb932d84da4',
  //   messagingSenderId: '907109666605',
  //   projectId: 'karty-host-dev-qa-02',
  //   storageBucket: 'karty-host-dev-qa-02.appspot.com',
  //   iosBundleId: 'qa.karty.app.karty',
  // );

  @override
  String get baseUrl => const String.fromEnvironment('BASE_URL');

  @override
  bool get isProd => false;



//   @override
//   // TODO: implement hashCode
//   String get sslCert => '''
// -----BEGIN CERTIFICATE-----
// MIIFPDCCBCSgAwIBAgIQRQ6RWlORo5YQFhypIdbfZjANBgkqhkiG9w0BAQsFADA7
// MQswCQYDVQQGEwJVUzEeMBwGA1UEChMVR29vZ2xlIFRydXN0IFNlcnZpY2VzMQww
// CgYDVQQDEwNXUjMwHhcNMjUwMTE0MTkwNTIzWhcNMjUwNDE0MTk1ODE2WjAkMSIw
// IAYDVQQDExlkZXZ4LmNvcmUua2FydHl3YWxsZXQuYXBwMIIBIjANBgkqhkiG9w0B
// AQEFAAOCAQ8AMIIBCgKCAQEAnpq4yjYlH7DkyEgjqMwCVwh5Ovl5bZlQNrMeOWdF
// sMIV5/F3SCEDd9Inw3B8Aqr428NqryRQ3rYcxu5ajiC72i6mWDfs0c5oGPDXznYf
// GW08ZbAI5EpLZP19KimwG49bPHgj8jPF7Ufvw/zevVfmP9XbexVN0067WNN/AKJR
// YYF6d6nPu4f4lq6PEKwynjnHoMnTNRt58Pc+ObDvP/DBYeYcgfbrav2ArwAqeV2Z
// +N8ra5D3puH8UPg15qbPq9/BPHL8jYN0K6hTD0zabFyYftzmwfeQ4KA+i7aQBVBl
// q97d5I2YyNonq8Sc27AmLvqLIxQ2E0QvlT3v+Xn/tXsOTwIDAQABo4ICUTCCAk0w
// DgYDVR0PAQH/BAQDAgWgMBMGA1UdJQQMMAoGCCsGAQUFBwMBMAwGA1UdEwEB/wQC
// MAAwHQYDVR0OBBYEFANeYWyDwtbGERtAA9I/JEiNP6f9MB8GA1UdIwQYMBaAFMeB
// 9f2OiNkAPE1jolAxJKDOI/4jMF4GCCsGAQUFBwEBBFIwUDAnBggrBgEFBQcwAYYb
// aHR0cDovL28ucGtpLmdvb2cvcy93cjMvUlE0MCUGCCsGAQUFBzAChhlodHRwOi8v
// aS5wa2kuZ29vZy93cjMuY3J0MCQGA1UdEQQdMBuCGWRldnguY29yZS5rYXJ0eXdh
// bGxldC5hcHAwEwYDVR0gBAwwCjAIBgZngQwBAgEwNgYDVR0fBC8wLTAroCmgJ4Yl
// aHR0cDovL2MucGtpLmdvb2cvd3IzL1M5dUJFdnZCak1VLmNybDCCAQMGCisGAQQB
// 1nkCBAIEgfQEgfEA7wB2AE51oydcmhDDOFts1N8/Uusd8OCOG41pwLH6ZLFimjnf
// AAABlGZrukUAAAQDAEcwRQIgMHzmulpzteS/+lLc7YhO9OGR9fFLHYfTWMET2ATi
// ztMCIQDrJSrdATt3yPEfXEAQKVDHwT6UEJDPbPwsPY38ZNpFUgB1AH1ZHhLheCp7
// HGFnfF79+NCHXBSgTpWeuQMv2Q6MLnm4AAABlGZrunYAAAQDAEYwRAIgaWZbtbBx
// SKjdxjF2pULsIeCWoARR1uLtrZfepfL93bMCICC0cY2IKlVrrm2ZBXmltuJQnlOy
// Zle4n0KwUgqRa3iGMA0GCSqGSIb3DQEBCwUAA4IBAQAH7Q2ecR0Os9vX44c/qH0P
// UVH4aYvfRUJi7/hnc4WU/kmAk8b35WfoMQ+6Yz9LreTEKoJXmHuwxiv1ZLEpmYRo
// G4A65P+2gNJSQjddPvWLvPM3dE7rzpTvrj4feuOEWlAEzBP/w4wZqXoh5jaYolWR
// W/AyeJLpuPnoUTWZxPVaYljNpsrwYoMDKOQnYrZOYdVUr+9e1POt9ybXhgkHMY3r
// YFeKYk73/+H8LI89apcNs0eEbL+7BXotUX7GR3mTXZtB4stSP3uirnWcpd38K4vW
// 2oHpmX9yORSsTpcXLf2ufnuTZBaYW7WOtySueOj+d33NehQLfAEmIglJhiCueU09
// -----END CERTIFICATE-----
// ''';

  // @override
  // Future<String> getPemCertForGCP() async {
  //   final String pemString =
  //       await rootBundle.loadString('assets/api_pk_devx.pem');
  //   return pemString;
  // }

  // @override
  // FirebaseOptions getFirebaseConfig() {
  //   switch (defaultTargetPlatform) {
  //     case TargetPlatform.android:
  //       return android;

  //     case TargetPlatform.fuchsia:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions have not been configured for macos - '
  //         'you can reconfigure this by running the FlutterFire CLI again.',
  //       );
  //     case TargetPlatform.iOS:
  //       return ios;
  //     // TODO: Handle this case.

  //     case TargetPlatform.linux:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions have not been configured for macos - '
  //         'you can reconfigure this by running the FlutterFire CLI again.',
  //       );
  //     case TargetPlatform.macOS:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions have not been configured for macos - '
  //         'you can reconfigure this by running the FlutterFire CLI again.',
  //       );
  //     case TargetPlatform.windows:
  //       throw UnsupportedError(
  //         'DefaultFirebaseOptions have not been configured for macos - '
  //         'you can reconfigure this by running the FlutterFire CLI again.',
  //       );
  //   }
  // }

  @override
  Future<void> configure(Locale? locale) async => runApp(
        MyApp(
          locale: locale,
        ),
      );
}
