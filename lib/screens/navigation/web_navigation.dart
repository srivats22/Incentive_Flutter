import 'package:flutter/material.dart';
import 'package:incentive_flutter/screens/account/account.dart';
import 'package:incentive_flutter/screens/current_task/currentTask.dart';
import 'package:incentive_flutter/screens/pending/pending.dart';
import 'package:incentive_flutter/screens/planned/planned.dart';

class WebNavigation extends StatefulWidget {
  @override
  _WebNavigationState createState() => _WebNavigationState();
}

class _WebNavigationState extends State<WebNavigation> {
  int currentPage = 0;
  final pages = [
    CurrentTask(),
    PendingTask(),
    Planned(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Incentive",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentPage,
              onDestinationSelected: (int index){
                setState(() {
                  currentPage = index;
                });
              },
              extended: true,
              selectedIconTheme: IconThemeData(color: Colors.tealAccent),
              selectedLabelTextStyle: TextStyle(color: Colors.tealAccent),
              destinations: [
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.task),
                  icon: Icon(Icons.task_outlined),
                  label: Text("Current tasks"),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.pending_actions),
                  icon: Icon(
                    Icons.pending_actions_outlined,
                  ),
                  label: Text("Pending tasks"),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.event),
                  icon: Icon(
                    Icons.event_outlined,
                  ),
                  label: Text("Planned Tasks"),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.account_circle),
                  icon: Icon(Icons.account_circle_outlined),
                  label: Text("Account"),
                )
              ],
            ),
            VerticalDivider(),
            Expanded(
              child: Center(
                child: pages.elementAt(currentPage),
              ),
            )
          ],
        ),
      ),
    );
  }
}
