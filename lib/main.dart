import 'package:flutter/material.dart';
import 'package:mxg/constants/theme.dart';
import 'package:mxg/screens/login_page.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices(false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MxG',
      navigatorKey: getIt<NavigationService>().navigatorKey,
      localizationsDelegates: getIt<LocalizationService>().localizationsDelegates,
      supportedLocales: getIt<LocalizationService>().supportedLocales,
      theme: lightTheme,
      home: LoginPage(),
    );
  }
}
