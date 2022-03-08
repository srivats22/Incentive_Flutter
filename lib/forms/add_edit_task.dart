import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

class AddEditTask extends StatefulWidget {
  final String screenName, userUid, docId, taskName, taskDesc, taskReward;
  final int priority;
  final bool isAdding, isPlanned;
  const AddEditTask(
      this.screenName,
      this.userUid,
      this.docId,
      this.taskName,
      this.taskDesc,
      this.taskReward,
      this.priority,
      this.isAdding,
      this.isPlanned);

  @override
  _AddEditTaskState createState() => _AddEditTaskState();
}

class _AddEditTaskState extends State<AddEditTask> {
  TextEditingController? taskName, taskDesc, taskReward;
  final GlobalKey<FormState> taskKey = new GlobalKey<FormState>();
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
    if (widget.isAdding == false) {
      taskName = new TextEditingController(text: widget.taskName);
      taskDesc = new TextEditingController(text: widget.taskDesc);
      taskReward = new TextEditingController(text: widget.taskReward);
      priority = widget.priority;
    } else {
      taskName = new TextEditingController();
      taskDesc = new TextEditingController();
      taskReward = new TextEditingController();
    }
    btnEnabled = !widget.isAdding;
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.screenName}",
          ),
        ),
        body: Form(
          key: taskKey,
          onChanged: () {
            if (taskKey.currentState!.validate()) {
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
                SizedBox(
                  width: screenWidth * .75,
                  child: UniversalPlatform.isIOS
                      ? CupertinoTextField(
                          controller: taskName,
                          placeholder: "Task Name",
                        )
                      : TextFormField(
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
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenWidth * .75,
                  child: UniversalPlatform.isIOS
                      ? CupertinoTextField(
                          controller: taskDesc,
                          placeholder: "Task Description",
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 256,
                          keyboardType: TextInputType.multiline,
                        )
                      : TextFormField(
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
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                        ),
                ),
                Visibility(
                  visible: UniversalPlatform.isIOS,
                  child: Text("Max words allowed: 256"),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenWidth * .75,
                  child: UniversalPlatform.isIOS
                      ? CupertinoTextField(
                          controller: taskReward,
                          placeholder: "Task Reward",
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 256,
                          keyboardType: TextInputType.multiline,
                        )
                      : TextFormField(
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
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                        ),
                ),
                Visibility(
                  visible: UniversalPlatform.isIOS,
                  child: Text("Max words allowed: 256"),
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
                Visibility(
                  visible: !UniversalPlatform.isIOS,
                  child: ButtonBar(
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
                        child:
                            widget.isAdding ? Text("Add Task") : Text("Save"),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: UniversalPlatform.isIOS,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      CupertinoButton.filled(
                        onPressed: () {
                          submitForm();
                        },
                        child:
                            widget.isAdding ? Text("Add Task") : Text("Save"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() {
    if (!widget.isAdding) {
      FirebaseFirestore.instance
          .collection("users")
          .doc("${widget.userUid}")
          .collection("tasks")
          .doc("${widget.docId}")
          .update({
        "priority": priority,
        "taskName": taskName!.text,
        "taskDescription": taskDesc!.text,
        "taskReward": taskReward!.text,
        "due": currDate,
        "isPlanned": widget.isPlanned
      });
      Navigator.of(context).pop();
    } else {
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
        "dueDate": FieldValue.serverTimestamp(),
        "isPlanned": widget.isPlanned
      });
      Navigator.of(context).pop();
    }
  }
}
