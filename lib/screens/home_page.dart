import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/screens/home_tab.dart';
import 'package:mxg/screens/profile_tab.dart';
import 'package:mxg/screens/progress_tab.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _tabController;

  void logout() {
    getIt<AuthService>().logout();
    getIt<NavigationService>().push(Routes.login, clear: true);
  }

  @override
  void initState() {
    _tabController = PersistentTabController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<WeightEntry>>(
      create: (context) => getIt<WeightEntryService>().getOrderedStream(),
      initialData: [],
      child: PersistentTabView(
        context,
        controller: _tabController,
        screenTransitionAnimation:
            ScreenTransitionAnimation(animateTabTransition: true),
        screens: [
          Center(
            child: HomeTab(),
          ),
          Center(
            child: ProgressTab(),
          ),
          Center(
            child: ProfileTab(),
          ),
        ],
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: ("Home"),
            activeColorPrimary: Theme.of(context).buttonColor,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.show_chart),
            title: ("Progress"),
            activeColorPrimary: Theme.of(context).buttonColor,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.account_circle_rounded),
            title: ("Profile"),
            activeColorPrimary: Theme.of(context).buttonColor,
            inactiveColorPrimary: Colors.grey,
          ),
        ],
        floatingActionButton: FloatingActionButton(
          onPressed: () => getIt<NavigationService>().showWeightEntryDialog(),
          child: Icon(Icons.add),
          elevation: 2,
        ),
      ),
    );
  }
}
