import 'dart:math';

import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
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
                      Navigator.of(context).pop();
                      _confettiController.play();
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
                                child: ConfettiWidget(
                                  confettiController: _confettiController,
                                  shouldLoop: false,
                                  blastDirection: -pi / 2,
                                  numberOfParticles: 5,
                                  child: Column(
                                    children: [
                                      Text(
                                          widget.taskReward.toString().trim() != "" ?
                                          "You can now enjoy your reward which was: "
                                              : "You just completed a task"
                                      ),
                                      Visibility(
                                        visible: widget.taskReward.toString().trim() != "",
                                        child: Text("${widget.taskReward}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.of(context)
                                        .pop();
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            );
                          }
                      );
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
                      _confettiController.play();
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
                                child: ConfettiWidget(
                                  confettiController: _confettiController,
                                  shouldLoop: false,
                                  blastDirection: -pi / 2,
                                  numberOfParticles: 5,
                                  child: Column(
                                    children: [
                                      Text(
                                          widget.taskReward.toString().trim() != "" ?
                                          "You can now enjoy your reward which was: "
                                              : "You just completed a task"
                                      ),
                                      Visibility(
                                        visible: widget.taskReward.toString().trim() != "",
                                        child: Text("${widget.taskReward}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.of(context)
                                        .pop();
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            );
                          }
                      );
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
}
