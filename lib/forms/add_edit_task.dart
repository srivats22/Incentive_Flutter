import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/noti/noti_helper.dart';
import 'package:incentive_flutter/widgets/custom_input.dart';
import 'package:universal_platform/universal_platform.dart';

class AddEditTask extends StatefulWidget {
  final String screenName, userUid, docId, taskName, taskDesc, taskReward;
  final int priority;
  final bool isAdding, isEditing, isPlanned;
  const AddEditTask(
      this.screenName,
      this.userUid,
      this.docId,
      this.taskName,
      this.taskDesc,
      this.taskReward,
      this.priority,
      this.isAdding,
      this.isEditing,
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
  bool isNotiPermissionGranted = false;

  DateTime selectedDate = DateTime.now();
  DateTime iOSTime = DateTime.now();
  DateTime fullDate = DateTime.now();
  final NotiHelper _notiHelper = NotiHelper();


  void notiInitialization() async{
    if (UniversalPlatform.isIOS) {
      bool? iosResult = await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      setState(() {
        isNotiPermissionGranted = iosResult!;
      });
    } else {
      bool? result = await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();

      setState(() {
        isNotiPermissionGranted = result!;
      });
    }
  }

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
    btnEnabled = widget.isAdding || widget.isEditing;
    initialization();
    notiInitialization();
  }

  Future _selectDate(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (time != null) {
      setState(() {
        fullDate = DateTimeField.combine(DateTime.now(), time);
      });
      await _notiHelper.scheduleNotifications(
          id: 0,
          title: taskName!.text,
          body: taskDesc!.text,
          time: fullDate);
    }
  }

  Future _iOSNotiCreater(BuildContext context) async{
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.white,
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            // backgroundColor: CupertinoColors.white,
            initialDateTime: iOSTime,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: false,
            // This is called when the user changes the date.
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                iOSTime = newDate;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final errorSnackBar = SnackBar(
      content: Text("Fields are empty",
        style: Theme.of(context).textTheme.caption
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
      backgroundColor: Colors.red,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.screenName}",
          ),
        ),
        body: Form(
          key: taskKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth * .75,
                  child: CustomInput(taskName!, "Task Name", "", "", false,
                      TextInputType.text, false, false),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: screenWidth * .75,
                  child: CustomInput(taskDesc!, "Task Description", "", "",
                      false, TextInputType.text, false, true),
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
                  child: CustomInput(taskReward!, "Task Reward", "", "", false,
                      TextInputType.text, false, true),
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
                      // selectedColor: Colors.tealAccent.withOpacity(.75),
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
                      // selectedColor: Colors.tealAccent.withOpacity(.75),
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
                      // selectedColor: Colors.tealAccent.withOpacity(.75),
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
                  visible: isNotiPermissionGranted,
                  child: ListTile(
                    onTap: (){
                      if(UniversalPlatform.isIOS){
                        _iOSNotiCreater(context);
                      }
                      else{
                        _selectDate(context);
                      }
                    },
                    leading: isIos ? Icon(CupertinoIcons.bell_fill) :
                    Icon(Icons.add_alert),
                    title: Text("Create Reminder"),
                  ),
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
                        onPressed: () {
                          if(widget.isAdding
                          && taskName!.text.isEmpty && taskDesc!.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                          }
                          else if(!widget.isAdding
                          && taskName!.text.isEmpty || taskDesc!.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                          }
                          else{
                            submitForm();
                          }
                        },
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
                      CupertinoButton(
                        onPressed: () async{
                          if(widget.isAdding
                              && taskName!.text.isEmpty && taskDesc!.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                          }
                          else if(!widget.isAdding
                              && taskName!.text.isEmpty || taskDesc!.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                          }
                          else{
                            if(widget.isAdding){
                              setState(() {
                                fullDate = iOSTime;
                              });
                              await _notiHelper.scheduleNotifications(
                                  id: 0,
                                  title: taskName!.text,
                                  body: taskDesc!.text,
                                  time: fullDate);
                            }
                            submitForm();
                          }
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
