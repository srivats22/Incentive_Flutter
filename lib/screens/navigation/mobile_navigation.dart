import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incentive_flutter/forms/add_edit_task.dart';
import 'package:incentive_flutter/forms/add_planned_task.dart';
import 'package:incentive_flutter/screens/account/account.dart';
import 'package:incentive_flutter/screens/current_task/currentTask.dart';
import 'package:incentive_flutter/screens/pending/pending.dart';
import 'package:incentive_flutter/screens/planned/planned.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../common.dart';

class MobileNav extends StatefulWidget {
  @override
  _MobileNavState createState() => _MobileNavState();
}

class _MobileNavState extends State<MobileNav> {
  User? user;
  String greeting = "";

  void initialization() async {
    var timeNow = DateTime.now().hour;
    if (timeNow < 12) {
      setState(() {
        greeting = "Good Morning";
      });
    } else if (timeNow >= 12 || timeNow < 16) {
      setState(() {
        greeting = "Afternoon";
      });
    } else {
      setState(() {
        greeting = "Good Evening";
      });
    }
    user = FirebaseAuth.instance.currentUser;
  }

  final pages = [
    CurrentTask(),
    PendingTask(),
    Account(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 100,
              child: Center(
                child: ListTile(
                  title: Text(
                    greeting,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    "${user?.displayName}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Task Related"),
            ),
            SizedBox(
              height: 5,
            ),
            customListTile(Icon(Icons.task), Icon(CupertinoIcons.doc_checkmark),
                "Today's Tasks", CurrentTask()),
            customListTile(Icon(Icons.pending_actions),
                Icon(Icons.pending_actions), "Pending Tasks", PendingTask()),
            customListTile(
                Icon(Icons.calendar_month),
                Icon(CupertinoIcons.calendar_today),
                "Planned Tasks",
                Planned()),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Others"),
            ),
            customListTile(
              Icon(Icons.add),
              Icon(CupertinoIcons.add),
              "Create Task",
              AddEditTask("Add Task", "${user!.uid}", "", "", "", "", 0, true,
                  false, false),
            ),
            customListTile(
              Icon(Icons.calendar_month),
              Icon(CupertinoIcons.calendar),
              "Plan Task",
              AddPlannedTask("${user!.uid}"),
            ),
            customListTile(
                ExcludeSemantics(
                  child: CircleAvatar(
                    child: Text("${user?.displayName![0].toUpperCase()}"),
                  ),
                ),
                ExcludeSemantics(
                  child: CircleAvatar(
                    child: Text("${user?.displayName![0].toUpperCase()}"),
                  ),
                ),
                "Account",
                Account()),
          ],
        ),
      ),
    );
  }

  Widget customListTile(
      Widget androidIcon, Widget iOSIcon, String title, Widget destination) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: OpenContainer(
        closedColor: Colors.transparent,
        openColor: Colors.transparent,
        openBuilder: (context, _) => destination,
        closedBuilder: (context, VoidCallback openContainer) => ListTile(
          onTap: openContainer,
          leading: isIos ? iOSIcon : androidIcon,
          title: Text(title),
        ),
      ),
    );
  }
}
