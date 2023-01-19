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
                  title: Text(greeting,
                    style: Theme.of(context).textTheme.headline5,),
                  subtitle: Text("${user?.displayName}",
                    style: Theme.of(context).textTheme.headline6,),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => Account()));
                    },
                    child: ExcludeSemantics(
                      child: CircleAvatar(
                        child: Text("${user?.displayName![0].toUpperCase()}"),
                        radius: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(indent: 20, endIndent: 20,),
            SizedBox(height: 5,),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Task Related"),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CurrentTask()));
                },
                leading: UniversalPlatform.isIOS ?
                Icon(CupertinoIcons.doc_checkmark_fill) : Icon(Icons.task),
                title: Text("Today's Tasks"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PendingTask()));
                },
                leading: Icon(Icons.pending_actions),
                title: Text("Pending Tasks"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Planned()));
                },
                leading: UniversalPlatform.isIOS ?
                Icon(CupertinoIcons.calendar_today) : Icon(Icons.calendar_month),
                title: Text("Planned Tasks"),
              ),
            ),
            Divider(indent: 20, endIndent: 20,),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Quick Actions"),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddEditTask("Add Task", "${user!.uid}", "", "", "",
                              "", 0, true, false, false)));
                },
                leading: UniversalPlatform.isIOS ?
                Icon(CupertinoIcons.add) : Icon(Icons.add),
                title: Text("Create Task"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:
                          (context) => AddPlannedTask("${user!.uid}")));
                },
                leading: UniversalPlatform.isIOS ?
                Icon(CupertinoIcons.calendar) : Icon(Icons.calendar_month),
                title: Text("Plan Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
