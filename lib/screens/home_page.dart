import 'package:flutter/material.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';

class HomePage extends StatelessWidget {

  void logout() {
    getIt<AuthService>().logout();
    getIt<NavigationService>().push(Routes.login, clear: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: logout,
        ),
      ),
    );
  }
}
