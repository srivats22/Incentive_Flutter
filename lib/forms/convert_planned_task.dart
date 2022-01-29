// form for converting a planned task to current task
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';

class ConvertPlannedTask extends StatefulWidget {
  final String userUid, taskName, taskDesc, docId;
  ConvertPlannedTask(this.userUid, this.taskName, this.taskDesc, this.docId);

  @override
  _ConvertPlannedTaskState createState() => _ConvertPlannedTaskState();
}

class _ConvertPlannedTaskState extends State<ConvertPlannedTask> {
  TextEditingController? taskName, taskDesc, taskReward;
  final GlobalKey<FormState> convertKey = new GlobalKey<FormState>();
  bool btnEnabled = false;
  int priority = 0;
  DateTime dt = DateTime.now();
  String? currDate = "";

  void initialization() {
    var month = dt.month.toString();
    var date = dt.day.toString();
    var year = dt.year.toString();
    setState(() {
      currDate = "$month-$date-$year";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskName = new TextEditingController(text: widget.taskName);
    taskDesc = new TextEditingController(text: widget.taskDesc);
    taskReward = new TextEditingController();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: convertKey,
          onChanged: () {
            if (convertKey.currentState!.validate()) {
              setState(() {
                btnEnabled = true;
              });
            }
          },
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text("Create Task"),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: screenWidth * .75,
                  child: TextFormField(
                    controller: taskName,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Task Name is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Task Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenWidth * .75,
                  child: TextFormField(
                    controller: taskDesc,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "Task Description is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Task Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 256,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenWidth * .75,
                  child: TextFormField(
                    controller: taskReward,
                    decoration: InputDecoration(
                      labelText: "Task Reward",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 256,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    FilterChip(
                      onSelected: (bool value) {
                        if (value) {
                          setState(() {
                            priority = 0;
                          });
                        } else {
                          setState(() {
                            priority = 0;
                          });
                        }
                      },
                      selectedColor: Colors.tealAccent.withOpacity(.75),
                      selected: priority == 0,
                      label: Text("Low"),
                    ),
                    FilterChip(
                      onSelected: (bool value) {
                        if (value) {
                          setState(() {
                            priority = 1;
                          });
                        } else {
                          setState(() {
                            priority = 0;
                          });
                        }
                      },
                      selectedColor: Colors.tealAccent.withOpacity(.75),
                      selected: priority == 1,
                      label: Text("Medium"),
                    ),
                    FilterChip(
                      onSelected: (bool value) {
                        if (value) {
                          setState(() {
                            priority = 2;
                          });
                        } else {
                          setState(() {
                            priority = 0;
                          });
                        }
                      },
                      selectedColor: Colors.tealAccent.withOpacity(.75),
                      selected: priority == 2,
                      label: Text("High"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Low is selected by default",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: btnEnabled
                          ? () {
                              submitForm();
                            }
                          : null,
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() {
    FirebaseFirestore.instance
        .collection("users")
        .doc("${widget.userUid}")
        .collection("tasks")
        .add({
      "priority": priority,
      "taskName": taskName!.text,
      "taskDescription": taskDesc!.text,
      "taskReward": taskReward!.text,
      "due": currDate,
    });
    fStore.collection("users")
        .doc("${widget.userUid}")
        .collection("planned")
        .doc("${widget.docId}").delete();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => Navigation()));
  }
}
