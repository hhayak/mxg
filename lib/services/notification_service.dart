import 'package:flutter/material.dart';

class NotificationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationService(this.navigatorKey);

  void showSnackMessage(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
