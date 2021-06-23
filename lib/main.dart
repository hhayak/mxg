import 'package:flutter/material.dart';
import 'package:mxg/constants/theme.dart';
import 'package:mxg/screens/login_page.dart';
import 'package:mxg/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String env = String.fromEnvironment('env', defaultValue: 'dev');
  await initServices(env);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MxG',
      navigatorKey: getIt<NavigationService>().navigatorKey,
      localizationsDelegates:
          getIt<LocalizationService>().localizationsDelegates,
      supportedLocales: getIt<LocalizationService>().supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: LoginPage(),
    );
  }
}
