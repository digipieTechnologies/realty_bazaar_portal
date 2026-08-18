import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class FirebaseOptions {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? storageBucket;
  final String? iosBundleId;

  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.storageBucket,
    this.iosBundleId,
  });
}

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPIwp5og0NZwaM-Tx-DqqyKrzMUELsh5c',
    appId: '1:608975718169:web:50aff6d372a6ca30d96788',
    messagingSenderId: '608975718169',
    projectId: 'brokerhive-platform',
    authDomain: 'brokerhive-platform.firebaseapp.com',
    storageBucket: 'brokerhive-platform.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvAOG3wrEpoNGLPVQWKjhGeD2DpahHPUQ',
    appId: '1:608975718169:android:b5e83a916088b4dbd96788',
    messagingSenderId: '608975718169',
    projectId: 'brokerhive-platform',
    storageBucket: 'brokerhive-platform.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUyeFhUpwW7MSlR7hNONvZ5uSqJ5qmHFg',
    appId: '1:608975718169:ios:a36d1a6ec30dd757d96788',
    messagingSenderId: '608975718169',
    projectId: 'brokerhive-platform',
    storageBucket: 'brokerhive-platform.firebasestorage.app',
    iosBundleId: 'com.example.brokerflowform',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUyeFhUpwW7MSlR7hNONvZ5uSqJ5qmHFg',
    appId: '1:608975718169:ios:4df5e8ec8ccba45dd96788',
    messagingSenderId: '608975718169',
    projectId: 'brokerhive-platform',
    storageBucket: 'brokerhive-platform.firebasestorage.app',
    iosBundleId: 'com.brokerhive.portal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCPIwp5og0NZwaM-Tx-DqqyKrzMUELsh5c',
    appId: '1:608975718169:web:0cba318488e756efd96788',
    messagingSenderId: '608975718169',
    projectId: 'brokerhive-platform',
    authDomain: 'brokerhive-platform.firebaseapp.com',
    storageBucket: 'brokerhive-platform.firebasestorage.app',
  );
}
