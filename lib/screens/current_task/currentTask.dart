import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/forms/add_edit_task.dart';
import 'package:incentive_flutter/widgets/empty_placeholder.dart';
import 'package:incentive_flutter/widgets/task_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class CurrentTask extends StatefulWidget {
  @override
  _CurrentTaskState createState() => _CurrentTaskState();
}

class _CurrentTaskState extends State<CurrentTask> {
  String currDate = "";
  User? user;
  DateTime dt = DateTime.now();
  bool isExpanded = true;

  initialization() {
    user = FirebaseAuth.instance.currentUser;
    var month = dt.month.toString();
    var date = dt.day.toString();
    var year = dt.year.toString();
    setState(() {
      currDate = "$month-$date-$year";
    });
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: fStore
                .collection("users")
                .doc(user!.uid)
                .collection("tasks")
                .orderBy("priority", descending: true)
                .where("due", isEqualTo: "$currDate")
                .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: EmptyPlaceholder("No Tasks Available"),
              );
            }
            return ListView(
              padding: EdgeInsets.all(5),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                var reward = data['taskReward'];
                return TaskCard(
                    user!.uid, document.id, data['taskName'],
                    data['taskDescription'], reward, data['due'],false, data['priority']
                );
              }).toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(229, 252, 246, 1),
          onPressed: (){
            Navigator.push(context, PageTransition(child:
            AddEditTask("Add Task", user!.uid, "", "", "", "", 0, true, false),
            type: PageTransitionType.bottomToTop));
          },
          label: Text("Add Task", style: TextStyle(color: Colors.black),),
          icon: Icon(Icons.add, color: Colors.black,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
