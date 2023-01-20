import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/forms/convert_planned_task.dart';
import 'package:incentive_flutter/widgets/empty_placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../forms/add_planned_task.dart';

class Planned extends StatefulWidget {
  const Planned({Key? key}) : super(key: key);

  @override
  _PlannedState createState() => _PlannedState();
}

class _PlannedState extends State<Planned> {
  String currDate = "";
  User? user;
  DateTime dt = DateTime.now();
  bool isExpanded = true;

  initialization() {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    TextStyle? _title =
    Theme.of(context).textTheme.headline6?.copyWith(color: Colors.black);
    TextStyle? _body =
    Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Planned Tasks"),
        ),
        body: StreamBuilder(
          stream: fStore
              .collection("users")
              .doc(user!.uid)
              .collection("planned")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: EmptyPlaceholder("No Planned Tasks Available"),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: (){
                    sheet(data['taskName'], data['taskDescription'], document.id);
                  },
                  child: Card(
                    elevation: 10,
                    color: Color.fromRGBO(250, 237, 236, 1.0),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['taskName'],
                          style: _title,),
                          SizedBox(height: 5,),
                          Text(data['taskDescription'],
                          style: _body,),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: (){
                                sheet(data['taskName'], data['taskDescription'], document.id);
                              },
                              icon: Icon(Icons.expand_more),
                              color: isDarkModeOn ? Colors.black : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(229, 252, 246, 1),
          onPressed: (){
            Navigator.push(context, PageTransition(child:
            AddPlannedTask(user!.uid),
                type: PageTransitionType.bottomToTop));
          },
          label: Text("Plan Task", style: TextStyle(color: Colors.black),),
          icon: Icon(Icons.add, color: Colors.black,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void sheet(String taskName, String taskDesc, String id){
    showModalBottomSheet(
        context: context,
        builder: (context){
          bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: MediaQuery.of(context).size.height * .40,
            child: ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(
                          new MaterialPageRoute(
                              builder: (context) =>
                                  ConvertPlannedTask(
                                      user!.uid, taskName,
                                      taskDesc,
                                      id)));
                    },
                    icon: Icon(Icons.edit),
                    color: isDarkModeOn ? Colors.white : Colors.black,
                  ),
                ),
                Text("Task Title",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 5,),
                Text(taskName, style: TextStyle(fontSize: 16),),
                Divider(indent: 10, endIndent: 10,),
                Text("Task Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 5,),
                Text(taskDesc, style: TextStyle(fontSize: 16),),
                Divider(indent: 10, endIndent: 10,),
                Visibility(
                  visible: UniversalPlatform.isIOS,
                  child: CupertinoButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      fStore
                          .collection("users")
                          .doc(user!.uid)
                          .collection("planned")
                          .doc(id).delete();
                    },
                    child: Text("Delete".toUpperCase(),
                      style: TextStyle(color: Colors.white),),
                    color: Colors.red,
                  ),
                ),
                Visibility(
                  visible: !UniversalPlatform.isIOS,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      fStore
                          .collection("users")
                          .doc(user!.uid)
                          .collection("planned")
                          .doc(id).delete();
                    },
                    child: Text("Delete".toUpperCase(),
                      style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
