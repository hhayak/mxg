import 'package:flutter/material.dart';
import 'package:mxg/screens/screens.dart';


class Routes {
  static const String root = '/';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String home = 'home';

}

class AppRouter {
  static Widget generatePage(String name, Object? arguments) {
    Widget page;
    switch (name) {
      case Routes.login:
        page = LoginPage();
        break;
      case Routes.signup:
        page = SignupPage();
        break;
      case Routes.home:
        page = HomePage();
        break;
      default:
        page = LoginPage();
        break;
    }
    return page;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var page = generatePage(settings.name!, settings.arguments);
    return MaterialPageRoute(builder: (_) => page);
  }
}
