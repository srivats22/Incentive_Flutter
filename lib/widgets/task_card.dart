import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incentive_flutter/forms/add_edit_task.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../common.dart';

class TaskCard extends StatefulWidget {
  final String userUid, docId, taskName, taskDesc, taskReward, due;
  final bool isPending;
  final int priority;
  TaskCard(this.userUid, this.docId, this.taskName,
      this.taskDesc, this.taskReward, this.due, this.isPending, this.priority);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isConfettiPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isPending && widget.priority == 0){
      return GestureDetector(
        onTap: (){
          _bottomSheet(context);
        },
        child: Card(
          elevation: 10,
          color: Color.fromRGBO(239, 247, 238, 1.0),
          child: content(context),
        ),
      );
    }
    if(!widget.isPending && widget.priority == 1){
      return GestureDetector(
        onTap: (){
          _bottomSheet(context);
        },
        child: Card(
          elevation: 10,
          color: Color.fromRGBO(255, 244, 230, 1.0),
          child: content(context),
        ),
      );
    }
    if(!widget.isPending && widget.priority == 2){
      return GestureDetector(
        onTap: (){
          _bottomSheet(context);
        },
        child: Card(
          elevation: 10,
          color: Color.fromRGBO(250, 237, 236, 1.0),
          child: content(context),
        ),
      );
    }
    return GestureDetector(
      onTap: (){
        _bottomSheet(context);
      },
      child: Card(
        color: Colors.red[100],
        elevation: 10,
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context){
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    TextStyle? _title =
    Theme.of(context).textTheme.headline6?.copyWith(color: Colors.black);
    TextStyle? _body =
    Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.black);
    TextStyle? _subtitle =
    Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.taskName,
              style: _title,),
          SizedBox(height: 5,),
          Text(widget.taskDesc,
          style: _body,),
          SizedBox(height: 5,),
          Text("Due Date: ${widget.due}",
              style: _subtitle,),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: (){
                _bottomSheet(context);
              },
              icon: Icon(Icons.expand_more),
              color: isDarkModeOn ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _bottomSheet(BuildContext context){
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height * .40,
            child: ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                Visibility(
                  visible: !widget.isPending,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) =>
                                AddEditTask("Edit task", widget.userUid,
                                    widget.docId, widget.taskName,
                                    widget.taskDesc,
                                    widget.taskReward, widget.priority,
                                    false, true, false)));
                      },
                      icon: Icon(Icons.edit),
                      color: isDarkModeOn ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Text("Task Title",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 5,),
                Text(widget.taskName, style: TextStyle(fontSize: 16),),
                Divider(indent: 10, endIndent: 10,),
                Text("Task Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 5,),
                Text(widget.taskDesc, style: TextStyle(fontSize: 16),),
                Divider(indent: 10, endIndent: 10,),
                Visibility(
                  visible: widget.taskReward != "",
                  child: Text("Task Reward",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                ),
                SizedBox(height: 5,),
                Visibility(
                  visible: widget.taskReward != "",
                  child: Text(widget.taskReward, style: TextStyle(fontSize: 16),),
                ),
                Visibility(
                  visible: UniversalPlatform.isIOS,
                  child: CupertinoButton(
                    onPressed: (){
                      deleteConfirmation();
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
                      deleteConfirmation();
                    },
                    child: Text("Delete".toUpperCase(),
                      style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void deleteConfirmation(){
    var _rewardText = widget.taskReward;
    const snackBar = SnackBar(
      content: Text('Task Completed'),
    );
    // reward is present
    if(_rewardText.isNotEmpty){
      Navigator.of(context).pop();
      fStore
          .collection("users")
          .doc(widget.userUid)
          .collection("tasks")
          .doc(widget.docId).delete();
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              scrollable: true,
              alignment: Alignment.center,
              content: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Text(
                        "You can now enjoy your reward which was:"
                    ),
                    Text("$_rewardText"),
                  ],
                ),
              ),
              actions: [
                Visibility(
                  visible: !UniversalPlatform.isIOS,
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.of(context)
                          .pop();
                    },
                    child: Text("Close"),
                  ),
                ),
                Visibility(
                  visible: UniversalPlatform.isIOS,
                  child: CupertinoButton(
                    onPressed: (){
                      Navigator.of(context)
                          .pop();
                    },
                    child: Text("Close"),
                  ),
                ),
              ],
            );
          }
      );
    }
    else{
      Navigator.of(context).pop();
      fStore
          .collection("users")
          .doc(widget.userUid)
          .collection("tasks")
          .doc(widget.docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
