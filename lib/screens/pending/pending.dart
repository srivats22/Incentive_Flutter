import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/widgets/empty_placeholder.dart';
import 'package:incentive_flutter/widgets/task_card.dart';

class PendingTask extends StatefulWidget {
  @override
  _PendingTaskState createState() => _PendingTaskState();
}

class _PendingTaskState extends State<PendingTask> {
  String currDate = "";
  User? user;
  DateTime dt = DateTime.now();

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
              .where("due", isNotEqualTo: "$currDate").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: EmptyPlaceholder("No Pending Tasks Available"),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                var reward = data['taskReward'];
                return TaskCard(
                    user!.uid, document.id, data['taskName'],
                    data['taskDescription'], reward, data['due'], true, data['priority']
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
