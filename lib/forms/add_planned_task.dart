import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

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
          backgroundColor: Colors.white,
          title: Text("Planned Task", style: TextStyle(color: Colors.black),),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Form(
          key: plannedKey,
          onChanged: (){
            if(plannedKey.currentState!.validate()){
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
                SizedBox(height: 5,),
                SizedBox(
                  width: screenWidth * .75,
                  child: TextFormField(
                    controller: taskName,
                    validator: (input){
                      if(input!.isEmpty){
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
                SizedBox(height: 10,),
                SizedBox(
                  width: screenWidth * .75,
                  child: TextFormField(
                    controller: taskDesc,
                    validator: (input){
                      if(input!.isEmpty){
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
          CupertinoButton.filled(
            onPressed: (){
              submitForm();
            },
            child: Text("Save"),
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
          onPressed: btnEnabled ? (){
            submitForm();
          } : null,
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
