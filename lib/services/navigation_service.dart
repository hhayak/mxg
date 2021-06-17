import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/routes.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mxg/widgets/weight_entry_dialog.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final history = _NavigationHistory();

  Future<dynamic> push(String routeName,
      {Object? arguments,
        bool replace = false,
        bool fade = false,
        bool clear = false}) {
    var page = AppRouter.generatePage(routeName, arguments);
    Route route;
    if (fade) {
      route = FadeRoute(page: page);
    } else {
      route = MaterialPageRoute(builder: (context) => page);
    }
    if (clear) {
      navigatorKey.currentState!.popUntil((route) => false);
    }
    if (replace) {
      return navigatorKey.currentState!.pushReplacement(route);
    } else {
      return navigatorKey.currentState!.push(route);
    }
  }

  void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  void pop([Object? result]) {
    navigatorKey.currentState!.pop(result);
  }

  Future<void> showWeightEntryDialog() async {
    showDialog<WeightEntry>(
        context: navigatorKey.currentContext!, builder: (context) => WeightEntryDialog());
  }
}

class _NavigationHistory {
  final history = <_NavigationHistoryEntry>[];

  Route? getRoute(String name) {
    var historyEntry =
    history.lastWhereOrNull((element) => element.name == name);
    return historyEntry?.route;
  }

  void push(String name, Route route) {
    history.add(_NavigationHistoryEntry(name, route));
  }

  void replace(String name, Route route) {
    var entry = _NavigationHistoryEntry(name, route);
    if (history.isNotEmpty) {
      history.last = entry;
    } else {
      history.add(entry);
    }
  }

  void pop() {
    history.removeLast();
  }

  void popUntil(String name) {
    while (history.isNotEmpty && history.last.name != name) {
      history.removeLast();
    }
  }
}

class _NavigationHistoryEntry {
  final String name;
  final Route route;

  _NavigationHistoryEntry(this.name, this.route);
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}
