import 'package:flutter/material.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/routes.dart';
import 'package:mxg/screens/home_tab.dart';
import 'package:mxg/screens/profile_tab.dart';
import 'package:mxg/services/all_services.dart';
import 'package:mxg/services/services.dart';
import 'package:mxg/widgets/weight_entry_dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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

  Future<void> showWeightEntryDialog() async {
    showDialog<WeightEntry>(
        context: context, builder: (context) => WeightEntryDialog());
  }

  @override
  void initState() {
    _tabController = PersistentTabController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _tabController,
      screenTransitionAnimation:
          ScreenTransitionAnimation(animateTabTransition: true),
      screens: [
        Center(
          child: HomeTab(),
        ),
        Center(
          child: Text('tab2'),
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
        onPressed: showWeightEntryDialog,
        child: Icon(Icons.add),
        elevation: 2,
      ),
    );
  }
}
