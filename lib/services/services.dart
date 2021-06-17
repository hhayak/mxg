import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'all_services.dart';
import 'package:flutter/foundation.dart';

export 'all_services.dart';

final getIt = GetIt.instance;

Future<void> initServices(String env) async {
  await Firebase.initializeApp();
  if (env == 'dev') {
    print('Using Emulators');
    String host = defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2:8080'
        : 'localhost:8080';
    FirebaseFirestore.instance.settings =
        Settings(host: host, sslEnabled: false);
    await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  }

  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<LocalizationService>(LocalizationService());
  getIt.registerSingleton<NotificationService>(
      NotificationService(getIt<NavigationService>().navigatorKey));

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<UserService>(UserService(FirebaseFirestore.instance));
  getIt.registerSingleton<WeightEntryService>(
      WeightEntryService(FirebaseFirestore.instance));

  getIt<AuthService>().authChanges().listen((user) {
    if (user != null) {
      print('Binding WeightEntryService to ${user.uid}');
      getIt<WeightEntryService>().bind(user.uid);
      getIt<UserService>().bind(user.uid);
    }
  });
}
