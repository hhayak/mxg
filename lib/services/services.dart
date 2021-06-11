import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'all_services.dart';

final getIt = GetIt.instance;

Future<void> initServices(bool useEmulator) async {
  await Firebase.initializeApp();
  if (useEmulator) {
    await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  }
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<LocalizationService>(LocalizationService());
  getIt.registerSingleton<NotificationService>(
      NotificationService(getIt<NavigationService>().navigatorKey));
}
