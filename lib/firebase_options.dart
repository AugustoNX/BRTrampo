import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        // TODO(firebase): rodar `flutterfire configure` para gerar as
        // opções específicas por plataforma e substituir este fallback.
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA5DECezrW2FEa7KgbLcdVj3rK4nGersrE',
    appId: '1:751494098822:web:ab175b3c1ccb2a08180607',
    messagingSenderId: '751494098822',
    projectId: 'brtrampo-a94a2',
    authDomain: 'brtrampo-a94a2.firebaseapp.com',
    databaseURL: 'https://brtrampo-a94a2-default-rtdb.firebaseio.com',
    storageBucket: 'brtrampo-a94a2.firebasestorage.app',
    measurementId: 'G-MX5SDGVM1P',
  );
}
