import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

import '../widgets/custom_input.dart';

class AddPlannedTask extends StatefulWidget {
  final String userUid;
  const AddPlannedTask(this.userUid);

  @override
  _AddPlannedTaskState createState() => _AddPlannedTaskState();
}

class _AddPlannedTaskState extends State<AddPlannedTask> {
  TextEditingController? taskName, taskDesc;
  final GlobalKey<FormState> plannedKey = new GlobalKey<FormState>();
  bool btnEnabled = false;
  bool isError = false;
  String errorMsg = "Fields cannot be empty";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskName = new TextEditingController();
    taskDesc = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Planned Task",),
        ),
        body: Form(
          key: plannedKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                SizedBox(height: 5,),
                SizedBox(
                  width: screenWidth * .75,
                  child: CustomInput(taskName!, "Task Name", "", "", false,
                    TextInputType.text, false, false),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: screenWidth * .75,
                  child: CustomInput(taskDesc!, "Task Description", "", "", false,
                      TextInputType.text, false, false),
                ),
                SizedBox(height: 5,),
                Visibility(
                  visible: isError,
                  child: Text(errorMsg,
                    style: Theme.of(context).textTheme.subtitle1
                        ?.copyWith(color: Colors.red),),
                ),
                SizedBox(height: 5,),
                btnBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnBar(){
    final errorSnackBar = SnackBar(
      content: Text("Fields are empty",
        style: Theme.of(context).textTheme.caption
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
      backgroundColor: Colors.red,
    );
    if(UniversalPlatform.isIOS){
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          CupertinoButton(
            onPressed: (){
              if(taskName!.text.isEmpty || taskDesc!.text.isEmpty){
                setState(() {
                  isError = true;
                });
              }
              else{
                submitForm();
              }
            },
            child: Text("Save"),
            color: Color.fromRGBO(0, 128, 128, 1),
          ),
        ],
      );
    }
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: (){
            if(taskName!.text.isEmpty || taskDesc!.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
              // setState(() {
              //   isError = true;
              // });
              // Future.delayed(Duration(seconds: 5), (){
              //   print("Wait for 10 seconds");
              // });
            }
            else{
              submitForm();
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  void submitForm(){
    FirebaseFirestore.instance.collection("users")
        .doc("${widget.userUid}").collection("planned")
        .add({
      "taskName": taskName!.text,
      "taskDescription": taskDesc!.text,
    });
    Navigator.of(context).pop();
  }
}
